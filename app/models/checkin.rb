class Checkin < ActiveRecord::Base
  attr_accessible :checked_in_at, :user_id, :venue_id, :venue_name

  CHECKIN_FIELDS = %w[
    data.createdAt
    data.venue.id
    data.venue.name
  ].join(',')

  def self.from_singly(data)
    self.new(
      :venue_id => data['data']['venue']['id'],
      :venue_name => data['data']['venue']['name'],
      :checked_in_at => Time.at(data['data']['createdAt'])
    )
  end

  def self.last(user)
    self.recent(user, 1).first
  end

  def self.recent(user, limit=2)
    Checkin.where(:user_id => user.id).
            order('checked_in_at desc').
            limit(limit).
            all
  end

  def self.sync(user)
    last_checkin = self.last(user)
    last_time = last_checkin ?  last_checkin.checked_in_at.to_i * 1000 : 0
    until_time = Time.now.to_i * 1000
    checkins = []
    singly = Singly.new(user.access_token)
    begin
      checkins = singly.checkins(
        :until => until_time,
        :since => last_time + 1,
        :limit => 500,
        :fields => CHECKIN_FIELDS
      ).map{|data| Checkin.from_singly(data)}
      checkins.each do |checkin|
        next if Checkin.exists?(
          :user_id => user.id,
          :checked_in_at => checkin.checked_in_at
        )
        checkin.user_id = user.id
        checkin.save
      end
      until_time = checkins.map(&:checked_in_at).min
      until_time = until_time.to_i * 1000 - 1 if until_time
    end while until_time && until_time > last_time
  end
end

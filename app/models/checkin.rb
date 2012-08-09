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

  def self.predict(checkins)
    checkins = checkins.sort_by(&:checked_in_at)
    all_checkins = Checkin.
      where(:user_id => checkins.first.user_id).
      order(:checked_in_at).
      all
    past = all_checkins.each_cons(3).select do |a, b, c|
      [a.venue_id, b.venue_id] == checkins.map(&:venue_id)
    end
    count = past.size
    guesses = past.
      group_by {|a, b, c| c.venue_id}.
      sort_by {|venue_id, tuples| -tuples.size}.
      first(3)

    guesses.map do |venue_id, tuples|
      venue_name = tuples.first.last.venue_name
      average_transit = tuples.map do |a, b, c|
        c.checked_in_at - b.checked_in_at
      end.inject(0.0, :+) / tuples.size
      OpenStruct.new({
        :venue_name => venue_name,
        :count => tuples.size,
        :probability => (100 * tuples.size / count).round,
        :arrival_time => checkins.last.checked_in_at + average_transit
      })
    end
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

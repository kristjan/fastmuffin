SinglyRailsSkeleton::Application.routes.draw do
  get "checkins/sync"

  match "auth/:service"          => "auth#service"
  match "auth/:service/callback" => "auth#callback"
  match "login"                  => "auth#login"
  match "logout"                 => "auth#logout"

  match "sync"                   => "checkins#sync"

  match "test"                   => "default#test"

  root :to                       => "default#home"
end

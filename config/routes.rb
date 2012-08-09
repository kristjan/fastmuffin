SinglyRailsSkeleton::Application.routes.draw do
  match "auth/:service"          => "auth#service"
  match "auth/:service/callback" => "auth#callback"
  match "login"                  => "auth#login"
  match "logout"                 => "auth#logout"
  root :to                       => "default#home"
end

# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :v1 do
    get 'time_clocks', to: 'controllers/time_clocks#index'
  end
end

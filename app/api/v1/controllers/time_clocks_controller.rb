# frozen_string_literal: true

module V1
  module Controllers
    class TimeClocksController < ApplicationController
      def index
        @users = User.all
        render json: @users
      end
    end
  end
end

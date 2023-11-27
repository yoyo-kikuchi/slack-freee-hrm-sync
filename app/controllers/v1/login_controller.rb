# frozen_string_literal: true

module V1
  class LoginController < ApplicationController
    def index
      render json: { status: 'SUCCESS', message: 'Create Successfullyv1' },
             status: 500
    end
  end
end

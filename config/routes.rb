# frozen_string_literal: true

Rails.application.routes.draw do
  mount OpenApi::Rswag::Ui::Engine => '/api-docs'
  mount OpenApi::Rswag::Api::Engine => '/api-docs'
end

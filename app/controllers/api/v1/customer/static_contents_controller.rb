class Api::V1::Customer::StaticContentsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def static_content
    if params[:type] == "customer"
      @static_content = StaticPage.and({title: params[:title]}, {:type => "customer"}).first
    elsif params[:type] == "store"
      @static_content = StaticPage.and({title: params[:title]}, {:type => "store"}).first 
    end
    render json: {responseCode: 200, responseMessage: "Content fetched successfully.",
                  content: {title: @static_content.try(:title), description: strip_tags(@static_content.try(:description)).try(:chomp)}}    
  end
end
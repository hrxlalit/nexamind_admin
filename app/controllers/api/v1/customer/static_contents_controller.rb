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

  def contact_us
    if params[:type] == "customer"
      @contact_us = ContactU.new(title: params[:title], description: params[:description], user_id: params[:id])
    elsif params[:type] == "store"
      @contact_us = ContactU.new(title: params[:title], description: params[:description], store_id: params[:id])
    end
    if @contact_us.save
      render :json => { :responseCode => 200,
                      :responseMessage => "Thank you.",
                      :reviews => @contact_us
                     }
    else
      render_message 402, "Contact us not created." 
    end
  end
end
class Api::V1::StaticContentsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def static_content
    if params[:type] == "Privacy Policy"
      @privacy_policy = StaticPage.where(title: params[:type]).first 
      return render json: {responseCode: 200, responseMessage: "Content fetched successfully.",
                content: {title: @privacy_policy.try(:title), description: strip_tags(@privacy_policy.try(:description)).try(:chomp)}
               }		
    elsif params[:type] == "Terms & Conditions"
      @terms_and_services = StaticPage.where(title: params[:type]).first
      return render json: {responseCode: 200, responseMessage: "Content fetched successfully.",
                content: {title: @terms_and_services.try(:title), description: strip_tags(@terms_and_services.try(:description)).try(:chomp)}
               }		
    elsif params[:type] == "About Us"
      @about_us = StaticPage.where(title: params[:type]).first 
      return render json: {responseCode: 200, responseMessage: "Content fetched successfully.",
                content: {title: @about_us.try(:title), description: strip_tags(@about_us.try(:description)).try(:chomp)}
               }	
    else
    	return render json:  {responseCode: 402, responseMessage: "Content is not present."}
    end
  end
end
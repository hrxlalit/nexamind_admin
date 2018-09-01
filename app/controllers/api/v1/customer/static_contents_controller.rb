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

   def privacy_policy
    @privacy_policy = StaticPage.where(title: "Privacy Policy").first
    return render json: {responseCode: 200, responseMessage: t('privacy_policy.successfully'),
              about_us: {title: @privacy_policy.try(:title), description: strip_tags(@privacy_policy.try(:description)).chomp}
             }    
  end
 
  def terms_and_condition
    @terms_and_services = StaticPage.where(title: "Terms & Conditions").first
    return render json: {responseCode: 200, responseMessage: t('terms_and_services.successfully'),
              about_us: {title: @terms_and_services.try(:title), description: strip_tags(@terms_and_services.try(:description)).chomp}
             }    
  end
end
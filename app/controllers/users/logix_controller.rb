# frozen_string_literal: true

class Users::LogixController < ApplicationController
  TYPEAHEAD_INSTITUTE_LIMIT = 50

  include UsersLogixHelper

  before_action :authenticate_user!, only: [:edit, :update, :groups]
  before_action :set_user, except: [:typeahead_educational_institute]

  def index
  end

  def favourites
    @projects = @user.rated_projects
  end

  def profile
    @profile = ProfileDecorator.new(@user)
  end

  def edit
  end

  def typeahead_educational_institute
    query = params[:query]
    institute_list = User.where("educational_institute LIKE :query", query: "%#{query}%")
                                     .distinct
                                     .limit(TYPEAHEAD_INSTITUTE_LIMIT)
                                     .pluck(:educational_institute)
    typeahead_array = institute_list.map { |item| { name: item } }
    render json: typeahead_array
  end

  def update
    if params.has_key?(:user) && profile_params
      @profile.update(profile_params)
    elsif params.has_key?(:settings) && settings_params
      @user.update(settings_params)
    else
      render 'errors/unacceptable', :status => :unacceptable
    end
  end

  def settings
  end

  def groups
    @user = authorize @user
    @groups_mentored = Group.where(id: Group.joins(:mentor).where(mentor: @user))
                            .select("groups.*, COUNT(group_members.id) as group_member_count")
                            .joins("left outer join group_members on \
                              (group_members.group_id = groups.id)")
                            .group("groups.id")
  end

  private
    def profile_params
      params.require(:user).permit(:name, :profile_picture, :country, :educational_institute,
       :subscribed)
    end

    def settings_params
      params.require(:settings).permit(:hide_external_navbar_links)
    end

    def set_user
      @profile = current_user
      @user = User.find(params[:id])
    end
end

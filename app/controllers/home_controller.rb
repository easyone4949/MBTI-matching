class HomeController < ApplicationController
  before_action :check_profile, except: [:view_profile, :create] 
  def index
    # if user_signed_in?
    #   redirect_to '/home/view_matchingHome'
    # end
  end
  
  def create 
    post = Post.new
    post.name = params[:name]
    post.age = params[:age]
    post.address = params[:address]
    post.hobby = params[:hobby]
    post.introduce = params[:introduce]
    post.kakao_id = params[:kakao_id]
    post.user_id = params[:user_id]
    post.save

    redirect_to "/home/view_matchingHome"
  end

  def read
  end

  def update
    post = Post.find_by(user_id: params[:user_id])
    post.name = params[:name]
    post.age = params[:age]
    post.address = params[:address]
    post.hobby = params[:hobby]
    post.introduce = params[:introduce]
    post.user_id = params[:user_id]
    post.kakao_id = params[:kakao_id]
    post.save
    redirect_to "/home/my_profile/#{post.id}"
  end

  def edit
     @post = Post.find_by(user_id: params[:user_id])
  end
  
  def delete
  end

  def new
  end
  

  def view_profile
      
  end
  
  def my_profile
     @my_data = Post.find_by(user_id: current_user.id)
  end
  
  def view_matchingHome
      
  end  

  def view_matching
    
    # 현재 유저
    matched = User.where(id: History.select(:matnum).where(user_id_id: current_user.id))
    #나와 매칭된 유저
    @selected_user = nil
    @matching_rank = nil
    search_sex = current_user.sex == "true" ? "false" : "true"
    
    #  3순위 search
    search_m = current_user.m
    search_t = current_user.t 
    search_i = current_user.i
    
    @third = User.where(sex: search_sex, t: search_t)
    # 2순위 search
    search_m = search_m == "e" ? "i" : "e"
    second_m = @third
    second_m = second_m.where(m: search_m)
    
    search_i = search_i == "j" ? "p" : "j"
    second_i = @third
    second_i = second_i.where(i: search_i)
    @second = second_m + second_i
    @second = @second & @second
    
    # 1순위
    @first = @third
    @first = @first.where(m: search_m, i: search_i)
    
    @first = @first.select {|elt| !matched.include? elt}
    @second = @second.select {|elt| !@first.include? elt}
    @third = @third.select {|elt| !@second.include? elt}
    
    if !@first.blank?
      @first_post = []
      @first.each do |matching|
        temp = Post.find_by(user_id: matching.id)
        if temp.nil?
          next
        end
        @first_post << temp
      end
      @first_post = @first_post.sample(2)
      @selected_user = @first_post
    end  
    if !@second.blank? && @selected_user.blank?
      @second_post = []
      @second.each do |matching|
        temp = Post.find_by(user_id: matching.id)
        if temp.nil?
          next
        end
        @second_post << temp
      end
      @second_post = @second_post.sample(2)
      @selected_user = @second_post
    end
    if !@third.blank? && @selected_user.blank?
      @third_post = []
      @third.each do |matching|
        temp = Post.find_by(user_id: matching.id)
        if temp.nil?
          next
        end
        @third_post << temp
      end
      @third_post = @third_post.sample(2)
      @selected_user = @third_post
    end
  end
  
  def history
      matching = params[:matching]
      history = History.new
      history.matnum = matching
      history.user_id_id = current_user.id
      history.save
      
      @history = Post.find_by(user_id: history.matnum)
  end
  def view_matHistory
    @histories = Post.where(user_id: History.select(:matnum).where(user_id_id: current_user.id))
  end
  
  private
    def check_profile
      if current_user
        profile = Post.find_by(user_id: current_user.id)
        if profile.nil?
          redirect_to home_view_profile_path
        end
      end
    end
end

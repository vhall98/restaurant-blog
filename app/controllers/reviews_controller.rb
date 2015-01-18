class ReviewsController < ApplicationController
  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.order('id desc').limit(5)
    if session[:user_id] && !session[:user_id].empty? 
      @userid = session[:user_id]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.json
  def new
    if (session[:user_id] && session[:user_id].length > 0)
      @review = Review.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @review }
      end
    else
       flash[:notice] = "Please log on to post"
       redirect_to '/reviews'
    end
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  # POST /reviews.json
  def create
    _review = review_params
    @review = Review.new(_review)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render json: @review, status: :created, location: @review }
      else
        format.html { render action: "new" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.json
  def update
    @review = Review.find(params[:id])

    respond_to do |format|
      _review = review_params
      if @review.update_attributes(_review)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url }
      format.json { head :no_content }
    end
  end
  
  #  POST  /reviews/comment
  def comment
    if (session[:user_id] && session[:user_id].length > 0)
      _comment = comment_params
      _comment[:date] = Time.now
      Review.find(params[:id]).comments.create(_comment)
      redirect_to :action => "show", :id => params[:id]
    else
       flash[:notice] = "Please log on or register to comment"
        redirect_to '/reviews/' + params[:id]
    end
  end
      
  #  POST   /reviews/search
  def search
    pattern = params[:searchFor]
    pattern = "%" + pattern + "%"
    @reviews = Review.where("title like ? OR article like ?", pattern, pattern)
  end

  def newuser
    # respond_to do |format|
      _user = user_params
      @user = User.new(user_params)
      if !@user.nil? && @user.save
        session[:user_id] = @user.userid
        flash[:notice] = 'New User ID was successfully created.'
      elsif !@user.nil? && !@user.id.nil?
        flash[:notice] = "Sorry, User ID already exists."
      else
        flash[:notice] = "All paramters must be entered."
      end
      # format.html {redirect_to '/reviews/register' }
      render 'reviews/register'
    # end
    
  end

  def validate
  
    respond_to do |format|
      user = User.authenticate(params[:userid], params[:password])
      if user
        session[:user_id] = user.userid
        flash[:notice] = 'User successfully logged in'
      else
        flash[:notice] = 'Invalid user/password'
      end
      format.html {redirect_to '/reviews' }
    end  
  end
  
  def logout
    session[:user_id] = nil
    redirect_to reviews_path
  end
  
  def user_params
    params.require(:user).permit(:email, :fullname, :password, :userid, :password_confirmation)
  end
  
  def review_params
    params.require(:review).permit(:article, :date, :poster, :title)
  end
  
  def comment_params
    params.require(:comment).permit(:comment, :date, :poster, :review_id)
  end
end

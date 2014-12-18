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
    @review = Review.new(params[:review])

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
      if @review.update_attributes(params[:review])
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
      params[:comment][:date] = Time.now
      Review.find(params[:id]).comments.create(params[:comment])
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
    respond_to do |format|
      if params[:userid].empty? || params[:password].empty? || params[:fullname].empty? || params[:email].empty?
        flash[:notice] = "All entries must be filled out."
      else
        user = User.new
        user.userid = params[:userid]
        user.password = params[:password]
        user.fullname = params[:fullname]
        user.email = params[:email]
        if user.save
          session[:user_id] = user.userid
          flash[:notice] = 'New User ID was successfully created.'
        else
          flash[:notice] = 'Sorry, User ID already exists.'
        end
      end
      format.html {redirect_to '/reviews/register' }
    end
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
  
  
end

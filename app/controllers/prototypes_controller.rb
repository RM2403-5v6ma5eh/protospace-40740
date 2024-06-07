class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :redirect_unless_owner, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def new
    @prototypes = Prototype.new
  #  binding.pry
  end

  def create
    @prototypes = Prototype.new(prototype_params)
    if @prototypes.save
      redirect_to "/"
    else
      render :new, status: :unprocessable_entity 
    end  
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end
  
  def edit
    @prototype = Prototype.find(params[:id])
  #  binding.pry
  end

  def update
    @prototype = Prototype.find(params[:id])
     if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path  
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def redirect_unless_owner
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end

end

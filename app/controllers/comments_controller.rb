class CommentsController < ApplicationController

def create
  @comment = Comment.new(comment_params)
  # binding.pry
  if @comment.save
    redirect_to prototype_path(@comment.prototype) # 今回の実装には関係ありませんが、このようにPrefixでパスを指定することが望ましいです。
  else
  #  binding.pry
    @prototype = @comment.prototype
    @comments = @prototype.comments
    render "prototypes/show"  # views/tweets/show.html.erbのファイルを参照しています。
  end
end

private
  def comment_params
    params.require(:comment).permit(:content).merge(prototype_id: params[:prototype_id], user_id: current_user.id)
  end

end

class SunflowerComments::Comments < SunflowerComments::Application

  def create
    @comment = Comment.new(params[:comment])
    @comment.ip_address = request.remote_ip
    @comment.user_id = current_user.id if logged_in?
    @comment.parent_id = params[:parent_id]
    @comment.parent_table = params[:parent_table]
    @comment.save
    redirect resource(@comment.parent)
  end

  def new
    @reply_to_comment = Comment[params[:reply_to_comment_id]]
    @parent = SunflowerComments.classes_hash[params[:parent_table]][params[:parent_id]]
    user_login = @reply_to_comment.user ? @reply_to_comment.user.login : 'Anonimas'
    @comment = Comment.new(
      :body => "<blockquote>\n<i><strong>#{h user_login}</strong> rašė:</i>\n\n\n#{@reply_to_comment.body}\n</blockquote>\n\n"
    )
    render
  end

  def report
    Comment.filter(:id => params[:id]).update(:reported => (:reported + 1))
    "Ačiū, kad pranešėte. Patikrinsime."
  end
end

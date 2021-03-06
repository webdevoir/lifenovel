json.posts do
  @posts.each do |post|
    json.partial! 'post', post: post
  end
end

json.comments do
  @posts.each do |post|
    post.comments.each do |comment|
      json.partial! '/api/comments/comment', comment: comment
    end
  end
end

json.likes do 
  @posts.each do |post|
    post.likes.each do |like| 
      json.partial! '/api/likes/like', like: like 
    end 
  end 
end 
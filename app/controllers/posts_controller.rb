class PostsController < ApplicationController
    before_action :set_user, only: [:update, :destroy]
                 
        def create
          post = Post.new(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: post.errors, status: :unprocessable_entity
          end
        end
      
        def update
          # post = Post.find(params[:id])
        if @post.update(post_params)
          render json: @post, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end 
      end
      
      def destroy
        # post = Post.find(params[:id])
        if @post.destroy
          render json: nil, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end
                 
      private
       
        def set_post
          @post = Post.find(params[:id])
        end
      
        def post_params
          params.permit(:content, :user_id)
        end
      end
      

class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :favor, :disfavor, :edit, :update]

  # GET /boards/1
  # GET /boards/1.json
  def show
    @all_topics = @board.topics.normal
    @topics = @all_topics.desc(:replied_at).page(params[:page]).per(15)
    @top_posts = @board.posts.top.desc(:top)
    render 'topics/index'
  end

  def favor
    authorize @board
    current_user.add_favorite(@board)
    redirect_to :back
  end

  def disfavor
    authorize @board
    current_user.remove_favorite(@board)
    redirect_to :back
  end

  def edit
    authorize @board
  end

  def update
    authorize @board
    respond_to do |format|
      if @board.update(board_params)
        format.html { flash[:notice] = I18n.t('global.update_successfully'); redirect_to edit_board_path(@board) }
      else
        format.html { render :edit }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id]) if params[:id]
      @board = Board.find_by(path: params[:path]) if params[:path]
    end

    def board_params
      params[:board].permit(:intro)
    end
end

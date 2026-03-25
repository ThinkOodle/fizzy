module FizzyAgentOrchestrator
  class BoardConfigsController < ApplicationController
    before_action :set_board
    before_action :require_admin

    def show
      redirect_to edit_board_agent_config_path(@board)
    end

    def edit
      @agent_config = FizzyAgentOrchestrator::BoardConfig.find_or_initialize_by(board_id: @board.id)
    end

    def update
      @agent_config = FizzyAgentOrchestrator::BoardConfig.find_or_initialize_by(board_id: @board.id)
      if @agent_config.update(agent_config_params)
        redirect_to edit_board_path(@board), notice: "Agent settings saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_board
      @board = Current.user.boards.find(params[:board_id])
    end

    def require_admin
      unless Current.user.can_administer_board?(@board)
        redirect_to @board, alert: "Admins only."
      end
    end

    def agent_config_params
      params.require(:board_config).permit(:system_prompt, default_tools: [])
    end
  end
end

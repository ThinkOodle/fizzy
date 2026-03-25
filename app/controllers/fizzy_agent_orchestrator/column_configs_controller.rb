module FizzyAgentOrchestrator
  class ColumnConfigsController < ApplicationController
    before_action :set_board
    before_action :set_column
    before_action :require_admin

    def show
      redirect_to edit_board_column_agent_config_path(@board, @column)
    end

    def edit
      @agent_config = FizzyAgentOrchestrator::ColumnConfig.find_or_initialize_by(column_id: @column.id)
    end

    def update
      @agent_config = FizzyAgentOrchestrator::ColumnConfig.find_or_initialize_by(column_id: @column.id)
      @agent_config.assign_attributes(agent_config_params)

      if @agent_config.save
        redirect_to board_path(@board), notice: "Column agent settings saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_board
      @board = Current.user.boards.find(params[:board_id])
    end

    def set_column
      @column = @board.columns.find(params[:column_id])
    end

    def require_admin
      unless Current.user.can_administer_board?(@board)
        head :forbidden
      end
    end

    def agent_config_params
      params.require(:column_config).permit(:system_prompt, :auto_spawn, :timeout_minutes)
    end
  end
end

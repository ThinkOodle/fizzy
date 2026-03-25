module FizzyAgentOrchestrator
  class ColumnConfigsController < ApplicationController
    before_action :set_column
    before_action :require_admin

    def show
      redirect_to edit_column_agent_config_path(@column)
    end

    def edit
      @agent_config = FizzyAgentOrchestrator::ColumnConfig.find_or_initialize_by(column_id: @column.id)
    end

    def update
      @agent_config = FizzyAgentOrchestrator::ColumnConfig.find_or_initialize_by(column_id: @column.id)
      if @agent_config.update(agent_config_params)
        redirect_back_or_to @column.board, notice: "Column agent settings saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_column
      @column = Column.find(params[:column_id])
      unless Current.user.can_administer_board?(@column.board)
        redirect_to @column.board, alert: "Admins only." and return
      end
    end

    def require_admin
      unless Current.user.can_administer_board?(@column.board)
        redirect_to @column.board, alert: "Admins only."
      end
    end

    def agent_config_params
      params.require(:column_config).permit(:system_prompt, :auto_spawn, :timeout_minutes, allowed_tools: [])
    end
  end
end

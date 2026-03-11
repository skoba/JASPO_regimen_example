# frozen_string_literal: true

class RegimenTemplatesController < ApplicationController
  def index
    @regimen_templates = RegimenTemplate.includes(regimens: [:cancer_type, :reference_edition])
                                        .order(:name)
  end

  def show
    @regimen_template = RegimenTemplate.includes(regimens: [:cancer_type, :reference_edition])
                                       .find(params[:id])
  end
end

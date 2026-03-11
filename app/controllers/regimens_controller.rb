# frozen_string_literal: true

class RegimensController < ApplicationController
  def index
    @regimens = Regimen.includes(:regimen_template, :cancer_type, :reference_edition)
                       .order('cancer_types.name, regimens.line_of_therapy')

    # がん腫でグループ化
    @regimens_by_cancer_type = @regimens.group_by(&:cancer_type)
  end

  def show
    @regimen = Regimen.includes(
      :regimen_template,
      :cancer_type,
      :reference_edition,
      regimen_drugs: [:drug, { regimen_drug_schedules: { schedule_timings: :timing_code } }]
    ).find(params[:id])
  end
end

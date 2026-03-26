# frozen_string_literal: true

class RegimensController < ApplicationController
  def index
    @drug_name = params[:drug_name].to_s.strip
    @regimens = Regimen.includes(:regimen_template, :cancer_type, :reference_edition,
                                 regimen_drugs: { drug: [], regimen_drug_schedules: :schedule_timings })
                       .order('cancer_types.name, regimens.line_of_therapy')

    if @drug_name.present?
      @regimens = @regimens.joins(:drugs)
                           .where('drugs.generic_name ILIKE :q OR drugs.brand_name ILIKE :q OR drugs.abbreviation ILIKE :q',
                                  q: "%#{@drug_name}%")
                           .distinct
    end

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

# frozen_string_literal: true

require "rails_helper"

describe Skill::Component do
  let(:options) { {} }
  let(:component) { Skill::Component.new(**options) }

  subject { rendered_content }

  it "renders" do
    render_inline(component)

    is_expected.to have_css "div"
  end
end

defmodule DhSmsWeb.ApiPatientView do
  use DhSmsWeb, :view

  def render("bulk_create.json", %{success: successes, fail: failures}) do
    %{success_count: length(successes), fail_count: length(failures)}
  end
end

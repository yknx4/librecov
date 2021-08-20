defmodule Librecov.Services.Github.Checks do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Checks
  alias Librecov.Build
  import Librecov.Helpers.Coverage

  def finish_check(
        token,
        owner,
        repo,
        %Build{
          coverage: coverage,
          previous_coverage: previous_coverage,
          commit_sha: commit
        },
        base_coverage
      ) do
    real_previous_coverage = base_coverage || previous_coverage || 0.0
    cov_dif = coverage_diff(coverage, real_previous_coverage) |> format_coverage()
    cov = coverage |> format_coverage()

    conn =
      token
      |> Connection.new()

    with {:ok, commit_check} <-
           conn
           |> Checks.checks_create(owner, repo,
             body: %{
               name: "LibreCov/commit",
               head_sha: commit,
               conclusion: "success",
               output: %{
                 title: "Coverage at #{cov} (#{cov_dif})",
                 summary: "#{cov}% (#{cov_dif})"
               }
             }
           ),
         {:ok, diff_check} <-
           conn
           |> Checks.checks_create(owner, repo,
             body: %{
               name: "LibreCov/diff",
               head_sha: commit,
               conclusion: coverage_diff(coverage, real_previous_coverage) |> diff_conclusion(),
               output: %{
                 title: "Coverage changed #{cov_dif}",
                 summary: "changed #{cov_dif}"
               }
             }
           ) do
      Logger.info("Finished check of commit #{commit} with diff: #{cov_dif} coverage: #{cov}.")
      {:ok, [commit_check, diff_check]}
    end
  end

  def create_check(token, commit, owner, repo) do
    token
    |> Connection.new()
    |> Checks.checks_create(owner, repo,
      body: %{
        name: "LibreCov/commit",
        head_sha: commit,
        output: %{
          title: "Waiting for tests to finish.",
          summary: "Waiting for tests to finish."
        }
      }
    )
  end

  defp diff_conclusion(diff) when diff == 0, do: "neutral"
  defp diff_conclusion(diff) when diff < 0, do: "failure"
  defp diff_conclusion(diff) when diff > 0, do: "success"
end

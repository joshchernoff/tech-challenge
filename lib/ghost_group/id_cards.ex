defmodule GhostGroup.IdCards do
  @moduledoc """
  The IdCards context.
  """

  import Ecto.Query, warn: false
  alias GhostGroup.Repo

  alias GhostGroup.IdCards.IdCard

  @doc """
  Returns the list of id_cards.

  ## Examples

      iex> list_id_cards()
      [%IdCard{}, ...]

  """
  def list_id_cards do
    Repo.all(IdCard)
  end

  @doc """
  Gets a single id_card.

  Raises `Ecto.NoResultsError` if the Id card does not exist.

  ## Examples

      iex> get_id_card!(123)
      %IdCard{}

      iex> get_id_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_id_card!(id), do: Repo.get!(IdCard, id)

  @doc """
  Creates a id_card.

  ## Examples

      iex> create_id_card(%{field: value})
      {:ok, %IdCard{}}

      iex> create_id_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_id_card(attrs \\ %{}) do
    %IdCard{}
    |> IdCard.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a id_card.

  ## Examples

      iex> update_id_card(id_card, %{field: new_value})
      {:ok, %IdCard{}}

      iex> update_id_card(id_card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_id_card(%IdCard{} = id_card, attrs) do
    id_card
    |> IdCard.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a id_card.

  ## Examples

      iex> delete_id_card(id_card)
      {:ok, %IdCard{}}

      iex> delete_id_card(id_card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_id_card(%IdCard{} = id_card) do
    Repo.delete(id_card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking id_card changes.

  ## Examples

      iex> change_id_card(id_card)
      %Ecto.Changeset{data: %IdCard{}}

  """
  def change_id_card(%IdCard{} = id_card, attrs \\ %{}) do
    IdCard.changeset(id_card, attrs)
  end
end

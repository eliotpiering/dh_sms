defmodule DhSms.AccountsTest do
  use DhSms.DataCase

  alias DhSms.Accounts

  describe "patients" do
    alias DhSms.Accounts.Patient

    @valid_attrs %{email: "some email", name: "some name", phone: "some phone"}
    @update_attrs %{email: "some updated email", name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{email: nil, name: nil, phone: nil}

    def patient_fixture(attrs \\ %{}) do
      {:ok, patient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_patient()

      patient
    end

    test "list_patients/0 returns all patients" do
      patient = patient_fixture()
      assert Accounts.list_patients() == [patient]
    end

    test "get_patient!/1 returns the patient with given id" do
      patient = patient_fixture()
      assert Accounts.get_patient!(patient.id) == patient
    end

    test "create_patient/1 with valid data creates a patient" do
      assert {:ok, %Patient{} = patient} = Accounts.create_patient(@valid_attrs)
      assert patient.email == "some email"
      assert patient.name == "some name"
      assert patient.phone == "some phone"
    end

    test "create_patient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_patient(@invalid_attrs)
    end

    test "update_patient/2 with valid data updates the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{} = patient} = Accounts.update_patient(patient, @update_attrs)
      assert patient.email == "some updated email"
      assert patient.name == "some updated name"
      assert patient.phone == "some updated phone"
    end

    test "update_patient/2 with invalid data returns error changeset" do
      patient = patient_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_patient(patient, @invalid_attrs)
      assert patient == Accounts.get_patient!(patient.id)
    end

    test "delete_patient/1 deletes the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{}} = Accounts.delete_patient(patient)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_patient!(patient.id) end
    end

    test "change_patient/1 returns a patient changeset" do
      patient = patient_fixture()
      assert %Ecto.Changeset{} = Accounts.change_patient(patient)
    end
  end
end

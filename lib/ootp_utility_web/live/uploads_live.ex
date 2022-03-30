defmodule OOTPUtilityWeb.UploadsLive do
  use Surface.LiveView

  alias Surface.Components.{Form, LiveFileInput}
  alias Surface.Components.Form.{Field, Label, Submit}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~F"""
    <Form for={:upload} multipart submit="save" change="validate">
      <Field name="csv_files">
        <Label text="CSV Zip Files" />
        <LiveFileInput upload={@uploads.csv_file} />
      </Field>
      <Submit label="Submit" />
    </Form>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     allow_upload(socket, :csv_file,
       accept: [".zip"],
       max_entries: 1,
       max_file_size: 8_000_000_000
     )}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    consume_uploaded_entries(
      socket,
      :csv_file,
      fn
        %{path: path}, %{client_name: client_name} ->
          dest = Path.join(["./csvs", client_name])

          # The `static/uploads` directory must exist for `File.cp!/2` to work.
          File.cp!(path, dest)

          OOTPUtility.Imports.import_from_archive(dest)

          {:ok, dest}
      end
    )

    {:noreply, socket}
  end
end

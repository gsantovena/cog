defmodule Cog.Config.Transforms do

  def expand_data_dir(dir), do: Path.expand(dir)

end

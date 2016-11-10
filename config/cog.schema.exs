@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [],
  import: [:cog],
  mappings: [
    "cog.mode": [
      datatype: [enum: [:dev, :test, :prod]],
      default: :prod,
      hidden: true
    ],
    "cog.telemetry": [
      commented: true,
      datatype: :boolean,
      default: true,
      doc: """
      ========================================================================
      Cog Telemetry - By default, Cog is configured to send an event to the
      Operable telemetry service every time it starts. This event contains a
      unique ID (based on the SHA256 of the UUID for your operable bundle),
      the Cog version number, and the Elixir mix environment (:prod, :dev, etc)
      that Cog is running under.

      If you would like to opt-out of sending this data, you can set the
      COG_TELEMETRY environment variable to "false".
      ========================================================================
      """,
      env_var: "COG_TELEMETRY",
    ],
    "cog.rules.mode": [
      commented: true,
      datatype: [enum: [:enforcing, :unenforcing]],
      default: :enforcing,
      doc: """
      ========================================================================
      Set this to :unenforcing to globally disable all access rules.
      NOTE: This is a global setting.
      ========================================================================
      """,
      env_var: "COG_RULE_ENFORCEMENT_MODE",
      to: "cog.access_rules"
    ],
    "cog.mqtt.host": [
      commented: true,
      datatype: :binary,
      default: "127.0.0.1",
      doc: """
      Message bus server host name
      """,
      to: "cog.message_bus.host",
      env_var: "COG_MQTT_HOST"
    ],
    "cog.mqtt_port": [
      commented: true,
      datatype: :integer,
      default: 1883,
      doc: """
      Message bus server port
      """,
      to: "cog.message_bus.port",
      env_var: "COG_MQTT_PORT"
    ],
    "cog.mqtt.cert_file": [
      commented: true,
      datatype: :binary,
      doc: """
      Path to SSL certificate
      """,
      to: "cog.message_bus.ssl_cert",
      env_var: "COG_MQTT_CERT_FILE"
    ],
    "cog.mqtt.key_file": [
      commented: true,
      datatype: :binary,
      doc: """
      Path to SSL private key file
      """,
      to: "cog.message_bus.ssl_key",
      env_var: "COG_MQTT_KEY_FILE"
    ],
    "cog.commands.allow_spoken": [
      commented: true,
      datatype: :boolean,
      default: false,
      doc: """
      Enables/disables spoken commands
      """,
      to: "cog.enable_spoken_commands",
      env_var: "ENABLE_SPOKEN_COMMANDS"
    ],
    "cog.command.prefix": [
      commented: true,
      datatype: :binary,
      default: "!",
      doc: """
      Prefix used to indicate spoken command
      """,
      env_var: "COG_COMMAND_PREFIX"
    ],
    "cog.pipeline.timeout": [
      commented: true,
      datatype: :integer,
      default: "60",
      doc: "Interactive pipeline execution timeout",
      to: "cog.Cog.Command.Pipeline.interactive_timeout",
      env_var: "COG_PIPELINE_TIMEOUT"
    ],
    "cog.trigger.timeout": [
      commented: true,
      datatype: :integer,
      default: "300",
      doc: "Trigger execution timeout",
      env_var: "COG_TRIGGER_TIMEOUT"
    ],
    "cog.embedded_bundle_version": [
      commented: true,
      datatype: :binary,
      default: "0.15.0",
      doc: """
      ========================================================================
      Embedded Command Bundle Version (for built-in commands)
      NOTE: Do not change this value unless you know what you're doing.
      ========================================================================
      """
    ],
    "cog.chat.providers": [
      commented: true,
      datatype: [list: :atom],
      doc: "Enabled chat providers",
      default: Cog.Chat.Slack.Provider
    ],
    "cog.chat.slack.api_token": [
      commented: true,
      datatype: :binary,
      doc: "Slack API token",
      env_var: "SLACK_API_TOKEN",
    ]
  ],
  transforms: [],
  validators: []
]

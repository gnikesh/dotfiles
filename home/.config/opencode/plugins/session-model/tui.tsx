import { Plugin, usePlugin } from "@opencode/plugin/tui"
import { createEffect, createMemo, createSignal, on, onCleanup } from "solid-js"

type ModelRef = { providerID?: string; id?: string; variant?: string } | undefined
type Session = { id: string; agent?: string; parentID?: string; model?: ModelRef }

function modelText(model: ModelRef) {
  if (!model?.id) return ""
  const provider = model.providerID ? `${model.providerID}/` : ""
  const variant = model.variant && model.variant !== "default" ? `#${model.variant}` : ""
  return `${provider}${model.id}${variant}`
}

// A subagent runs on `agents.<id>.model`, which is usually not the parent's model,
// but once you navigate into it with `down` there is nothing naming that model:
// the parent's composer header is gone. This line appears only inside a subagent
// session, so the parent view is untouched.
function Badge(props: { sessionID: string | undefined }) {
  const context = usePlugin()
  const [revision, setRevision] = createSignal(0)

  createEffect(
    on(
      () => [props.sessionID, revision()] as const,
      async ([sessionID]) => {
        if (sessionID) await context.data.session.sync(sessionID)
      },
    ),
  )

  const stop = context.data.listen(({ details }) => {
    if (details.type.startsWith("session.")) setRevision((value) => value + 1)
  })
  onCleanup(() => stop())

  const label = createMemo(() => {
    revision()
    const sessionID = props.sessionID
    if (!sessionID) return ""
    const session = context.data.session.get(sessionID) as Session | undefined
    if (!session?.parentID) return ""
    return modelText(session.model) || modelText(context.ui.model.current())
  })

  return <text fg={context.theme.text.base}>{label()}</text>
}

export default Plugin.define({
  id: "session.model.badge",
  setup(context) {
    return context.ui.slot({
      prepend: "session.composer.top",
      render: (props) => <Badge sessionID={props.sessionID} />,
    })
  },
})

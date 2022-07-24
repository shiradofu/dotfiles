// 認証が成功したらサーバから以下のような HTML を返してもらう想定
// <html><script>window.close();</script></html>

declare const OAUTH2_ENDPOINT: string

export const oauth2Popup = () =>
  new Promise<boolean>((resolve) => {
    const width = 500
    const height = 700
    const url = OAUTH2_ENDPOINT
    const name = 'googleOAuth2Popup'
    const left = window.screenX + (window.outerWidth - width) / 2
    const top = window.screenY + (window.outerHeight - height) / 2.5
    const popupWindow = window.open(
      url,
      name,
      `height=${height},width=${width},left=${left},top=${top}`
    )

    if (!popupWindow) throw new Error('Failed to open popup window')

    const interval = window.setInterval(() => {
      if (!popupWindow || popupWindow.closed) {
        window.clearInterval(interval)
        resolve(true)
      }
    }, 500)
  })

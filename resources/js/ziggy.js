const Ziggy = {"url":"http:\/\/localhost","port":null,"defaults":{},"routes":{"sanctum.csrf-cookie":{"uri":"sanctum\/csrf-cookie","methods":["GET","HEAD"]},"dashboard":{"uri":"dashboard","methods":["GET","HEAD"]},"customer.dashboard":{"uri":"customer\/dashboard","methods":["GET","HEAD"]},"restaurant.dashboard":{"uri":"restaurant\/dashboard","methods":["GET","HEAD"]},"profile.edit":{"uri":"profile","methods":["GET","HEAD"]},"profile.update":{"uri":"profile","methods":["PATCH"]},"profile.destroy":{"uri":"profile","methods":["DELETE"]},"menu":{"uri":"menu","methods":["GET","HEAD"]},"register":{"uri":"register","methods":["GET","HEAD"]},"login":{"uri":"login","methods":["GET","HEAD"]},"password.request":{"uri":"forgot-password","methods":["GET","HEAD"]},"password.email":{"uri":"forgot-password","methods":["POST"]},"password.reset":{"uri":"reset-password\/{token}","methods":["GET","HEAD"],"parameters":["token"]},"password.store":{"uri":"reset-password","methods":["POST"]},"verification.notice":{"uri":"verify-email","methods":["GET","HEAD"]},"verification.verify":{"uri":"verify-email\/{id}\/{hash}","methods":["GET","HEAD"],"parameters":["id","hash"]},"verification.send":{"uri":"email\/verification-notification","methods":["POST"]},"password.confirm":{"uri":"confirm-password","methods":["GET","HEAD"]},"password.update":{"uri":"password","methods":["PUT"]},"logout":{"uri":"logout","methods":["POST"]},"storage.local":{"uri":"storage\/{path}","methods":["GET","HEAD"],"wheres":{"path":".*"},"parameters":["path"]}}};
if (typeof window !== 'undefined' && typeof window.Ziggy !== 'undefined') {
  Object.assign(Ziggy.routes, window.Ziggy.routes);
}
// Align Ziggy base URL with backend origin from axios baseURL when available
if (typeof window !== 'undefined') {
  const setFromUrl = (base) => {
    try {
      const u = new URL(base);
      // Use origin to include protocol, hostname, and port
      Ziggy.url = u.origin;
      // Keep port for any consumers that still read it explicitly
      Ziggy.port = u.port ? parseInt(u.port, 10) : null;
    } catch (e) {
      // Fallback to window.location
      if (window.location) {
        Ziggy.url = window.location.origin;
        Ziggy.port = window.location.port ? parseInt(window.location.port, 10) : null;
      }
    }
  };

  if (window.axios && window.axios.defaults && window.axios.defaults.baseURL) {
    setFromUrl(window.axios.defaults.baseURL);
  } else if (window.location) {
    setFromUrl(window.location.href);
  }
}
export { Ziggy };

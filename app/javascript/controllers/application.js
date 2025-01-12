// app/javascript/application.js

import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-loading";
import controllers from "./controllers";
const application = Application.start();

// Automatically load all Stimulus controllers from the controllers directory
application.load(controllers);

application.load(definitionsFromContext(context));

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

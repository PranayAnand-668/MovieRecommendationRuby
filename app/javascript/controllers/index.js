import { application } from "../application";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { definitionsFromContext } from "@hotwired/stimulus";
const context = require.context(".", true, /\.js$/);
application.load(definitionsFromContext(context));

eagerLoadControllersFrom("controllers", application)

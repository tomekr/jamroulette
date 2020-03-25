import * as ActiveStorage from "@rails/activestorage"
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "styles/styles"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// This is so that we can reference images in app/javascript/packs/images
const images = require.context("../images", true)
// @ts-ignore
const imagePath = name => images(name, true)

// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

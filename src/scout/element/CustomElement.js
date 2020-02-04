class ScoutCustomElement extends HTMLElement {

  constructor() {
    super();
    this.__shadow = this.attachShadow({ mode: 'open' });
    this._hx_constructor();
  }

  // Compat for HX, for now. Hopefully won't be needed in the
  // future?
  _hx_constructor() {}

}

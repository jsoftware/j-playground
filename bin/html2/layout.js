// layout
// vstate 0=hidden, 1=show  (view)
// v/h prop current left (vertical), top (horizontal) proportion of data panes

"use strict";

let mbarsize, tbarsize, topsize;

// ---------------------------------------------------------------------
var layout = new function() {

 let r = new Object();

 let O = console.log;
 let hprop, vprop, vstate;
 let panes;

 hprop = vprop = 0.5;
 vstate = 0;

 // ---------------------------------------------------------------------
 r.centerpanes = function() {
  vprop = hprop = 0.5;
  resizer();
 };

 // ---------------------------------------------------------------------
 r.closeviewer = function() {
  vstate = 0;
  resizer();
 };

 // ----------------------------------------------------------------------
 r.exec = function(str) {
  return eval(str);
 };

 // ---------------------------------------------------------------------
 // for testing...
 r.fini = function() {
  editopen();
 };

 // ---------------------------------------------------------------------
 r.getmainheight = function() {
  return Math.max(0, getheight(mainpane) - topsize);
 };

 // ---------------------------------------------------------------------
 r.getsideheight = function() {
  return Math.max(0, getheight(sidepane) - topsize);
 };

 // ---------------------------------------------------------------------
 r.getviewheight = function() {
  return Math.max(0, getheight(viewpane) - topsize - 2);
 };

 // ---------------------------------------------------------------------
 r.heights = function() {
  O("body=" + getheight(document.body) + ", tbar=" + getheight(tbar) +
   ", topsize=" + topsize + ", panes=" + getheight(panes) +
   ", mainpane=" + getheight(mainpane) + ", main=" + getheight(main) +
   ", sidepane=" + getheight(sidepane) + ", side=" + getheight(side) +
   ", viewpane=" + getheight(viewpane) + ", view=" + getheight(view));
 };

 // ---------------------------------------------------------------------
 // called at outset or when panes are flipped
 r.init = function() {

  panes = getid("panes");

  topsize = getheight(maintop);
  mbarsize = getwidth(vb);
  tbarsize = getheight(tbar);

  hb.onmousedown = slider;
  vb.onmousedown = slider;
 };

 // ---------------------------------------------------------------------
 r.openview = function() {
  vstate = 1;
  resizer();
 };

 // ---------------------------------------------------------------------
 r.size = function() {
  let h, m, s, t, w, bh, lh, lw, rh, rw, th, tw;

  h = getheight(document.body) - tbarsize;
  w = getwidth(panes);
  setheight(panes, h);

  // panex 0
  if (panex == 0) {
   setheight(vb, h);
   setheight(splitpane, h);
   setheight(main, h - topsize);
   show(vb);
   lw = Math.floor(hprop * (w - mbarsize));
   setwidth(mainpane, lw);
   setwidth(splitpane, w - lw - mbarsize);

   if (vstate) {
    rh = h - 2 * topsize - mbarsize;
    th = Math.max(0, Math.floor(vprop * rh));
    setheight(view, th - 1);
    setheight(side, rh - th - 1);
    show(hb);
    show(viewpane);
   } else {
    hide(viewpane);
    hide(hb);
    setheight(side, h - topsize);
   }
  } else {

   show(hb);

   t = mbarsize;
   rh = h - 2 * topsize - t;
   th = topsize + Math.max(0, Math.floor(vprop * rh));

   setheight(splitpane, th);
   setheight(mainpane, h - th - t);
   setheight(main, h - th - t - topsize);

   if (vstate) {
    setheight(vb, th);
    show(vb);
    t = getwidth(vb);
    rw = w - t;
    tw = Math.max(0, Math.floor(hprop * rw));
    setwidth(sidepane, tw);
    setheight(side, th - topsize);
    setwidth(side, tw);
    setwidth(viewpane, rw - tw - 2);
    setheight(view, th - topsize);
    setwidth(view, rw - tw - 2);
    show(viewpane);
   } else {
    hide(viewpane);
    hide(vb);
    setheight(side, th - topsize);
    setwidth(sidepane, w);
    setwidth(side, w);
   }
  };

  cmsetsize();
 };

 // ---------------------------------------------------------------------
 r.state = function() {
  O("vstate=" + vstate + ", panex,hprop,vprop=" + panex + ", " +
   round(hprop, 0.001) + ", " + round(vprop, 0.001));
 };

 // ---------------------------------------------------------------------
 r.widths = function() {
  O("body=" + window.innerWidth + ", tbar=" + getwidth(tbar) +
   ", panes=" + getwidth(panes) +
   ", splitpane=" + getwidth(splitpane) + ", sidepane=" + getwidth(sidepane) +
   ", mainpane=" + getwidth(mainpane) + ", main=" + getwidth(main));
 };

 // sliders ------------------------------------------------------------
 function slider(e) {
  e.preventDefault();
  e.stopPropagation();
  let em = this;
  let id = em.id;
  let dir = (id === "vb") ? "left" : "right";
  let pos = "client" + ((id === "vb") ? "X" : "Y");
  em.style.position = "relative";
  let start = e[pos];
  let diff = 0;

  function slidemove(e) {
   e.preventDefault();
   e.stopPropagation();
   diff = e[pos] - start;
   em.style[dir] = diff + "px";
  }

  function slidend(e) {
   e.preventDefault();
   e.stopPropagation();
   em.style[dir] = null;
   em.style.position = "static";
   if (id === "vb")
    slidevb(diff);
   else
    slidehb(diff);
   document.body.onmousemove = null;
   document.body.onmouseleave = document.body.onmouseup = null;
  }

  document.body.onmousemove = slidemove;
  document.body.onmouseleave = document.body.onmouseup = slidend;

 }

 // ---------------------------------------------------------------------
 function slidehb(d) {
  let h, p, x;
  if (panex === 0)
   h = getheight(view);
  else
   h = getheight(splitpane) - topsize;
  x = h + d;
  p = x / (getheight(panes) - 2 * topsize - mbarsize);
  vprop = Math.min(1, Math.max(0, p));
  resizer();
 }

 // ---------------------------------------------------------------------
 function slidevb(d) {
  let x, w;
  if (panex === 0)
   w = getwidth(main);
  else
   w = getwidth(side);
  x = w + d;
  x = x / (getwidth(panes) - getwidth(vb) - 2);
  hprop = Math.max(0, Math.min(1, x));
  resizer();
 }

 // ---------------------------------------------------------------------
 return r;
}();

var state = layout.state;

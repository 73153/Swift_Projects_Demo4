// Playground - noun: a place where people can play

import UIKit

let r = 255
let g = 0
let b = 255

//var h = i << 2

var h = 0xff00ff


var rr = h >> 16 & 0xff
var gg = h >> 8 & 0xff
var bb = h >> 0 & 0xff

var hh = r << 16 + g << 8 + b << 0
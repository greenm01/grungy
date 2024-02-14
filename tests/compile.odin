package tests

import "core:testing"
import "core:fmt"

import "../backend"
import "../buffer"
import "../text"
import "../layout"

@(test)
compile :: proc(t: ^testing.T) {
   fmt.println("compile success")
}

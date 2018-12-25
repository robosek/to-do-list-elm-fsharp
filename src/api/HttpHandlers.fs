namespace api

module HttpHandlers =

    open Microsoft.AspNetCore.Http
    open FSharp.Control.Tasks.V2.ContextInsensitive
    open Giraffe
    open api.Models

    let handleGetHello =
        fun (next : HttpFunc) (ctx : HttpContext) ->
            task {
                let response = {
                    Text = "Hello world, from Giraffe!"
                }
                return! json response next ctx
            }
    let handleGetHello2 =
        fun (next: HttpFunc) (ctx: HttpContext) ->
            task {
                let response ={
                    Text = "Hello World 2 master!"
                }
                return! json response next ctx
            }
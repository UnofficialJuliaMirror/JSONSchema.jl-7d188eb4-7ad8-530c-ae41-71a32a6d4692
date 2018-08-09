using JSONSchema, JSON

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end



tsurl = "https://github.com/json-schema-org/JSON-Schema-Test-Suite/archive/master.zip"




using BinaryProvider

BinaryProvider.download(tsurl, prefix, verbose=true)

prefix = mktempdir()
prod = FileProduct(prefix, "JSON-Schema-Test-Suite-master/tests/draft4")

tsurl2 = "file://C:/Users/frtestar/Downloads/JSON-Schema-Test-Suite-master.zip"


using BinDeps
@BinDeps.setup

destdir = mktempdir()
dwnldfn = joinpath(destdir, "test-suite.zip")
unzipdir = joinpath(destdir, "test-suite")
run(@build_steps begin
    CreateDirectory(destdir, true)
    FileDownloader(tsurl, dwnldfn)
    CreateDirectory(unzipdir, true)
    FileUnpacker(dwnldfn, unzipdir, "JSON-Schema-Test-Suite-master/tests")
end)


######## Source = https://github.com/json-schema-org/JSON-Schema-Test-Suite.git  #######

unzipdir = "c:/temp"
tsdir = joinpath(unzipdir, "JSON-Schema-Test-Suite-master/tests/draft4")
@testset "JSON schema test suite (draft 4)" begin
    @testset "$tfn" for tfn in filter(n -> ismatch(r"\.json$",n), readdir(tsdir))
        fn = joinpath(tsdir, tfn)
        schema = JSON.parsefile(fn)
        @testset "- $(subschema["description"])" for subschema in (schema)
            spec = Schema(subschema["schema"])
            @testset "* $(subtest["description"])" for subtest in subschema["tests"]
                @test isvalid(subtest["data"], spec) == subtest["valid"]
            end
        end
    end
end



#  MAP
fn = joinpath(tsdir, "definitions.json")
schema = JSON.parsefile(fn)
subschema = schema[1]
spec = Schema(subschema["schema"])
for subtest in subschema["tests"]
    info("- ", subtest["description"],
         " : ", isvalid(subtest["data"], spec),
         " / ", subtest["valid"])
end

ttt = JSONSchema.HTTP.URI(subschema["schema"]["\$ref"])
fieldnames(ttt)
clipboard(ttt)
ttt.scheme
uri = ttt
id0 = JSONSchema.HTTP.URI("")

JSONSchema.toabsoluteURI(uri, id0)

typeof(uri)

methods(JSONSchema.toabsoluteURI)



if uri.scheme == ""  # uri is relative to base uri => change just the path of id0
  uri = HTTP.URI(scheme   = id0.scheme,
                 userinfo = id0.userinfo,
                 host     = id0.host,
                 port     = id0.port,
                 query    = id0.query,
                 path     = "/" * uri.path)
end
uri




tmpuri = "http://json-schema.org/draft-04/schema"
conf = (verbose=2,)

HTTP.get(tmpuri; verbose=2)
HTTP.request("GET", tmpuri)



ENV["https_proxy"] = ENV["http_proxy"]

spec0 = subschema["schema"]
mkSchema(subschema["schema"])
subtest = subschema["tests"][1]
x, s = subtest["data"], spec
check(x, s)
subtest["valid"]

typeof(s["properties"]["foo"])
s0 = spec
s = spec.asserts["items"][2]

asserts = copy(s.asserts)

macroexpand( quote @doassert asserts "not" begin
    check(x, keyval) && return "satisfies 'not' assertion $notassert"
end end)



#################################################################################

using JSONSchema
sch = JSON.parsefile(joinpath(@__DIR__, "vega-lite-schema.json"))

@time (sch2 = Schema(sch);nothing)

sch2 = Schema(sch)


jstest = JSON.parse("""
    {
      "\$schema": "https://vega.github.io/schema/vega-lite/v2.json",
      "description": "A simple bar chart with embedded data.",
      "data": {
        "values": [
          {"a": "A","b": 28}, {"a": "B","b": 55}, {"a": "C","b": 43},
          {"a": "D","b": 91}, {"a": "E","b": 81}, {"a": "F","b": 53},
          {"a": "G","b": 19}, {"a": "H","b": 87}, {"a": "I","b": 52}
        ]
      },
      "mark": "bar",
      "encoding": {
        "x3": {"field": "a", "type": "ordinal"},
        "y": {"field": "b", "type": "quantitative"}
      }
    }

    """)

isvalid(jstest, sch2)



myschema = Schema("""
 {
    "properties": {
       "foo": {},
       "bar": {}
    },
    "required": ["foo"]
 }""")


isvalid(JSON.parse("{ \"foo\": true }"), myschema) # true
isvalid(JSON.parse("{ \"bar\": 12.5 }"), myschema) # false

myschema["properties"]






diagnose("{ "foo": true }", myschema) # nothing
diagnose("{ "bar": 12.5 }", myschema)


issue = ret.issues[1]
function shorterror(issue::SingleIssue)
    out  = (length(issue.path)==0) ? "" : "in `" * join(issue.path, ".") * "` : "
    out * issue.msg
end

function shorterror(issue::OneOfIssue)
    out = "one of these issues : \n"
    for is in issue.issues
        out *= " - " * shorterror(is) * "\n"
    end
    out
end

import Base: show

function show(io::IO, issue::OneOfIssue)
    out = "one of these issues : \n"
    for is in issue.issues
        out *= " - " * shorterror(is) * "\n"
    end
    println(IO, out)
end

show(ret)




ms = shorterror(ret)
println(ms)



Base.Markdown.MD("""
# aaa
 - _error_ here !


 """)


Profile.clear()
@profile evaluate(jstest, sch2)

Profile.print()

5+6

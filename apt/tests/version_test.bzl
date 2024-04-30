"unit tests for version parsing"

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//apt/private:version.bzl", "version")

def _parse_version_test(ctx):
    env = unittest.begin(ctx)
    asserts.equals(env, version.parse("1:1.4.1-1"), ("1", "1.4.1", "1"))
    asserts.equals(env, version.parse("7.1.ds-1"), (None, "7.1.ds", "1"))
    asserts.equals(env, version.parse("10.11.1.3-2"), (None, "10.11.1.3", "2"))
    asserts.equals(env, version.parse("4.0.1.3.dfsg.1-2"), (None, "4.0.1.3.dfsg.1", "2"))
    asserts.equals(env, version.parse("0.4.23debian1"), (None, "0.4.23debian1", None))
    asserts.equals(env, version.parse("1.2.10+cvs20060429-1"), (None, "1.2.10+cvs20060429", "1"))
    asserts.equals(env, version.parse("0.2.0-1+b1"), (None, "0.2.0", "1+b1"))
    asserts.equals(env, version.parse("4.3.90.1svn-r21976-1"), (None, "4.3.90.1svn-r21976", "1"))
    asserts.equals(env, version.parse("1.5+E-14"), (None, "1.5+E", "14"))
    asserts.equals(env, version.parse("20060611-0.0"), (None, "20060611", "0.0"))
    asserts.equals(env, version.parse("0.52.2-5.1"), (None, "0.52.2", "5.1"))
    asserts.equals(env, version.parse("7.0-035+1"), (None, "7.0", "035+1"))
    asserts.equals(env, version.parse("1.1.0+cvs20060620-1+2.6.15-8"), (None, "1.1.0+cvs20060620-1+2.6.15", "8"))
    asserts.equals(env, version.parse("1.1.0+cvs20060620-1+1.0"), (None, "1.1.0+cvs20060620", "1+1.0"))
    asserts.equals(env, version.parse("4.2.0a+stable-2sarge1"), (None, "4.2.0a+stable", "2sarge1"))
    asserts.equals(env, version.parse("1.8RC4b"), (None, "1.8RC4b", None))
    asserts.equals(env, version.parse("0.9~rc1-1"), (None, "0.9~rc1", "1"))
    asserts.equals(env, version.parse("2:1.0.4+svn26-1ubuntu1"), ("2", "1.0.4+svn26", "1ubuntu1"))
    asserts.equals(env, version.parse("2:1.0.4~rc2-1"), ("2", "1.0.4~rc2", "1"))
    return unittest.end(env)

version_parse_test = unittest.make(_parse_version_test)

def _version_compare_test(ctx):
    env = unittest.begin(ctx)
    asserts.true(env, version.lt("0", "a"))
    asserts.true(env, version.lt("1.0", "1.1"))
    asserts.true(env, version.lt("1.2", "1.11"))
    asserts.true(env, version.lt("1.0-0.1", "1.1"))
    asserts.true(env, version.lt("1.0-0.1", "1.0-1"))
    asserts.true(env, version.eq("1.0", "1.0"))
    asserts.true(env, version.eq("1.0-0.1", "1.0-0.1"))
    asserts.true(env, version.eq("1:1.0-0.1", "1:1.0-0.1"))
    asserts.true(env, version.eq("1:1.0", "1:1.0"))
    asserts.true(env, version.lt("1.0-0.1", "1.0-1"))
    asserts.true(env, version.gt("1.0final-5sarge1", "1.0final-5"))
    asserts.true(env, version.gt("1.0final-5", "1.0a7-2"))
    asserts.true(env, version.lt("0.9.2-5", "0.9.2+cvs.1.0.dev.2004.07.28-1.5"))
    asserts.true(env, version.lt("1:500", "1:5000"))
    asserts.true(env, version.gt("100:500", "11:5000"))
    asserts.true(env, version.gt("1.0.4-2", "1.0pre7-2"))
    asserts.true(env, version.lt("1.5~rc1", "1.5"))
    asserts.true(env, version.lt("1.5~rc1", "1.5+b1"))
    asserts.true(env, version.lt("1.5~rc1", "1.5~rc2"))
    asserts.true(env, version.gt("1.5~rc1", "1.5~dev0"))
    return unittest.end(env)

version_compare_test = unittest.make(_version_compare_test)

def _version_sort_test(ctx):
    env = unittest.begin(ctx)
    asserts.equals(env, version.sort(["1.5~rc2", "1.0.4-2", "1.5~rc1"]), ["1.0.4-2", "1.5~rc1", "1.5~rc2"])
    asserts.equals(env, version.sort(["1.0a7-2", "1.0final-5sarge1", "1.0final-5"], reverse = True), ["1.0final-5sarge1", "1.0final-5", "1.0a7-2"])
    return unittest.end(env)

version_sort_test = unittest.make(_version_sort_test)

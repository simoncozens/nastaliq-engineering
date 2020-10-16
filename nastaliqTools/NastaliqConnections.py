import os
import csv
import fontFeatures

GRAMMAR = """
NastaliqConnections_Args = <(~';' anything)+>:filename -> (filename,)
"""
VERBS = ["NastaliqConnections"]


class NastaliqConnections:
    @classmethod
    def action(self, parser, filename):
        rules = {}
        reachable = set([])
        basedir = os.path.dirname(parser.current_file)
        trypath = os.path.join(basedir, filename)

        if not os.path.exists(trypath):
            trypath = filename
            if not os.path.exists(trypath):
                raise ValueError("Couldn't find connections file %s" % trypath)

        with open(trypath) as csvfile:
            reader = csv.DictReader(csvfile)
            for line in reader:
                left_glyph = line["Left Glyph"]
                remainder = list(line.items())[1:]
                for (g, v) in remainder:
                    old = g + "1"
                    if v == "1" or v == 1 or not v:
                        continue
                    replacement = g + str(v)
                    if not old in rules:
                        rules[old] = {}
                    if not replacement in rules[old]:
                        rules[old][replacement] = []
                    rules[old][replacement].append(left_glyph)

        r = fontFeatures.Routine(name="connections", flags=0x8)
        for oldglyph in rules:
            for replacement in rules[oldglyph]:
                context = rules[oldglyph][replacement]
                reachable |= set(context)
                reachable |= set([oldglyph, replacement])
                r.addRule(
                    fontFeatures.Substitution(
                        [[oldglyph]],
                        [[replacement]],
                        postcontext=[context],
                        reverse=True,
                    )
                )
        parser.fontfeatures.namedClasses["reachable_glyphs"] = tuple(sorted(reachable))

        return [r]

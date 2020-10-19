import fontFeatures
from fontFeatures.fontProxy import FontProxy
import re
import warnings

GRAMMAR = """
Ligatures_Args = ws -> ()
"""
VERBS = ["Ligatures"]


class Ligatures:
    prefixes = ["ALIF", "BE", "JIM", "DAL", "RE", "SIN", "SAD", "TOE", "AIN", "FE", "QAF", "QAF", "KAF", "GAF", "LAM", "MIM", "NUN", "VAO", "VAO", "HAYC", "HAYA", "CH_YE", "BARI_YE"]
    a_prefix = "|".join(prefixes)
    ligature = f"^({a_prefix})_({a_prefix})([ifmu])1$"

    @classmethod
    def action(self, parser):
        glyphs = FontProxy(parser.font).glyphs
        rules = []
        for g in glyphs:
          m = re.match(self.ligature, g)
          if not m:
            continue
          first, second, position = m[1],m[2],m[3]
          if position == "u":
            first = first+"i1"
            second = second+"f1"
            rules.append(fontFeatures.Substitution(
              [ [first], [second] ],
              [ [g] ]
            ))
          if position == "f":
            first = first+"m1"
            second = second+"f1"
            rules.append(fontFeatures.Substitution(
              [ [first], [second] ],
              [ [g] ]
            ))

        return [fontFeatures.Routine(name="Ligatures", rules=rules, flags=0x8)]

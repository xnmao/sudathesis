from re import sub

file_0 = 'biblio.txt' # EndNote
file_1 = 'reference.bib'
print(f'{file_0} -> {file_1}')

formulas = {'Pt3Co', 'Pt3Ni', 'FeN4', 'CoN4', 'ZnN4', 'NiN4', 'Co3W3C'}  # 一般的化学式
words = {
    ' O2 ': r' \ch{O2} ', ' e- ': r' \ch{e-} ', ' Cu+ ': r' \ch{Cu+} ', # 短词左右加空格
    'Fe-n4': r'Fe-\ch{N4}', # 防止变成减号
    'M–n4–C': r'M-\ch{N4}-C', 'DFT-d': 'DFT-D',
    'irxruytazo2': r'\ch{Ir_{$x$}Ru_{$y$}Ta_{$z$}O_{2}}', 'irxru1−xo2': r'\ch{Ir_{x}Ru_{1-x}O_{2}}',
    'T=250': '$T$=250', 'n-propanol': '$n$-propanol', # 公式
    'Ir0.5M0.5O2 (m = cr, Ru or Pb)': r' \ch{Ir_{0.5}M_{0.5}O_{2}} (M = Cr, Ru or Pb)',
    'tm = cr, Mn, Fe, Mo, Ru, W and Os, and x = f and S': 'TM = Cr, Mn, Fe, Mo, Ru, W and Os, and X = F and S',
    'oxides — attempt': r'oxides\ —\ attempt',
} # 与正则表达式冲突的化学式

formulas.update({'H2O', 'CO2', 'RuO2', 'IrO2', 'C1'})

lines = open(file_0, 'r', encoding='utf-8').readlines()
for i, line in enumerate(lines):
    if line.lstrip().startswith('title'):
        for formula in formulas:
            if formula in lines[i]:
                lines[i] = sub('%s'%formula, r'\\ch{%s}'%formula, lines[i])
        for k, v in words.items():
            if k in lines[i]:
                lines[i] = lines[i].replace(k, v)
open(file_1, 'w', encoding='utf-8').writelines(lines)

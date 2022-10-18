#-*- encoding:utf-8 -*-
from __future__ import print_function

import sys
try:
    reload(sys)
    sys.setdefaultencoding('utf-8')
except:
    pass

import codecs
from textrank4zh import TextRank4Keyword, TextRank4Sentence
for i in range(2357, 7012):
    print (i)
    text = codecs.open(f"txt/{i}", 'r', 'utf-8').read()
    tr4w = TextRank4Keyword()

    tr4w.analyze(text=text, lower=True, window=2)  # py2中text必须是utf8编码的str或者unicode对象，py3中必须是utf8编码的bytes或者str对象

    # print( '关键词：' )
    result = []
    for item in tr4w.get_keywords(10, word_min_len=2):
        # print(item.word, item.weight)
        result.append(item.word)

    # print(result)
    keywords = ((",").join(result))
    f = open(f"keywords/{i}", "w+")
    f.write(keywords)
    f.close()
    print (i)
    # print()
    # print( '关键短语：' )
    # for phrase in tr4w.get_keyphrases(keywords_num=20, min_occur_num= 2):
    #     print(phrase)

    # tr4s = TextRank4Sentence()
    # tr4s.analyze(text=text, lower=True, source = 'all_filters')

    # print()
    # print( '摘要：' )
    # for item in tr4s.get_key_sentences(num=3):
        # print(item.index, item.weight, item.sentence)  # index是语句在文本中位置，weight是权重

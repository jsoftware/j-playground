NB. Copyright (c) 1990-2026, Jsoftware Inc.

require 'graphics/gl2 graphics/png'
coclass 'jviewmax'
coinsert 'jgl2 jni jaresu'

NB. Colormaps.
NB. Some of below colormaps are based on colormaps from various sources i.e:
NB. https://github.com/GalacticDynamics-Oxford/Agama/blob/master/doc/Colormaps.pdf
NB. https://research.google/blog/turbo-an-improved-rainbow-colormap-for-visualization/
NB. User may also specify their own colormap by x in viewmat.
turboc =: 16bff30123b 16bff321543 16bff33184a 16bff341b51 16bff351e58 16bff36215f 16bff372466 16bff38276d 16bff392a73 16bff3a2d79 16bff3b2f80 16bff3c3286 16bff3d358b 16bff3e3891 16bff3f3b97 16bff3f3e9c 16bff4040a2 16bff4143a7 16bff4146ac 16bff4249b1 16bff424bb5 16bff434eba 16bff4451bf 16bff4454c3 16bff4456c7 16bff4559cb 16bff455ccf 16bff455ed3 16bff4661d6 16bff4664da 16bff4666dd 16bff4669e0 16bff466be3 16bff476ee6 16bff4771e9 16bff4773eb 16bff4776ee 16bff4778f0 16bff477bf2 16bff467df4 16bff4680f6 16bff4682f8 16bff4685fa 16bff4687fb 16bff458afc 16bff458cfd 16bff448ffe 16bff4391fe 16bff4294ff 16bff4196ff 16bff4099ff 16bff3e9bfe 16bff3d9efe 16bff3ba0fd 16bff3aa3fc 16bff38a5fb 16bff37a8fa 16bff35abf8 16bff33adf7 16bff31aff5 16bff2fb2f4 16bff2eb4f2 16bff2cb7f0 16bff2ab9ee 16bff28bceb 16bff27bee9 16bff25c0e7 16bff23c3e4 16bff22c5e2 16bff20c7df 16bff1fc9dd 16bff1ecbda 16bff1ccdd8 16bff1bd0d5 16bff1ad2d2 16bff1ad4d0 16bff19d5cd 16bff18d7ca 16bff18d9c8 16bff18dbc5 16bff18ddc2 16bff18dec0 16bff18e0bd 16bff19e2bb 16bff19e3b9 16bff1ae4b6 16bff1ce6b4 16bff1de7b2 16bff1fe9af 16bff20eaac 16bff22ebaa 16bff25eca7 16bff27eea4 16bff2aefa1 16bff2cf09e 16bff2ff19b 16bff32f298 16bff35f394 16bff38f491 16bff3cf58e 16bff3ff68a 16bff43f787 16bff46f884 16bff4af880 16bff4ef97d 16bff52fa7a 16bff55fa76 16bff59fb73 16bff5dfc6f 16bff61fc6c 16bff65fd69 16bff69fd66 16bff6dfe62 16bff71fe5f 16bff75fe5c 16bff79fe59 16bff7dff56 16bff80ff53 16bff84ff51 16bff88ff4e 16bff8bff4b 16bff8fff49 16bff92ff47 16bff96fe44 16bff99fe42 16bff9cfe40 16bff9ffd3f 16bffa1fd3d 16bffa4fc3c 16bffa7fc3a 16bffa9fb39 16bffacfb38 16bffaffa37 16bffb1f936 16bffb4f836 16bffb7f735 16bffb9f635 16bffbcf534 16bffbef434 16bffc1f334 16bffc3f134 16bffc6f034 16bffc8ef34 16bffcbed34 16bffcdec34 16bffd0ea34 16bffd2e935 16bffd4e735 16bffd7e535 16bffd9e436 16bffdbe236 16bffdde037 16bffdfdf37 16bffe1dd37 16bffe3db38 16bffe5d938 16bffe7d739 16bffe9d539 16bffebd339 16bffecd13a 16bffeecf3a 16bffefcd3a 16bfff1cb3a 16bfff2c93a 16bfff4c73a 16bfff5c53a 16bfff6c33a 16bfff7c13a 16bfff8be39 16bfff9bc39 16bfffaba39 16bfffbb838 16bfffbb637 16bfffcb336 16bfffcb136 16bfffdae35 16bfffdac34 16bfffea933 16bfffea732 16bfffea431 16bfffea130 16bfffe9e2f 16bfffe9b2d 16bfffe992c 16bfffe962b 16bfffe932a 16bfffe9029 16bfffd8d27 16bfffd8a26 16bfffc8725 16bfffc8423 16bfffb8122 16bfffb7e21 16bfffa7b1f 16bfff9781e 16bfff9751d 16bfff8721c 16bfff76f1a 16bfff66c19 16bfff56918 16bfff46617 16bfff36315 16bfff26014 16bfff15d13 16bfff05b12 16bffef5811 16bffed5510 16bffec530f 16bffeb500e 16bffea4e0d 16bffe84b0c 16bffe7490c 16bffe5470b 16bffe4450a 16bffe2430a 16bffe14109 16bffdf3f08 16bffdd3d08 16bffdc3b07 16bffda3907 16bffd83706 16bffd63506 16bffd43305 16bffd23105 16bffd02f05 16bffce2d04 16bffcc2b04 16bffca2a04 16bffc82803 16bffc52603 16bffc32503 16bffc12302 16bffbe2102 16bffbc2002 16bffb91e02 16bffb71d02 16bffb41b01 16bffb21a01 16bffaf1801 16bffac1701 16bffa91601 16bffa71401 16bffa41301 16bffa11201 16bff9e1001 16bff9b0f01 16bff980e01 16bff950d01 16bff920b01 16bff8e0a01 16bff8b0902 16bff880802 16bff850702 16bff810602 16bff7e0502 16bff7a0403
mistc =: 16bff4e01c5 16bff4e0ac5 16bff4d12c6 16bff4c17c6 16bff4b1cc7 16bff4b20c7 16bff4a24c8 16bff4927c8 16bff482ac8 16bff472dc9 16bff4630c9 16bff4533ca 16bff4435ca 16bff4338cb 16bff423acb 16bff413dcc 16bff403fcc 16bff3f41cc 16bff3e44cd 16bff3d46cd 16bff3b48cd 16bff3a4acd 16bff394cce 16bff374ece 16bff3650ce 16bff3553ce 16bff3355ce 16bff3257cd 16bff3058cd 16bff2f5acd 16bff2e5ccd 16bff2c5ecc 16bff2b60cc 16bff2962cc 16bff2864cb 16bff2666cb 16bff2567ca 16bff2469ca 16bff226bc9 16bff216dc9 16bff1f6ec8 16bff1e70c8 16bff1d72c7 16bff1c73c7 16bff1a75c6 16bff1977c6 16bff1878c5 16bff177ac5 16bff167bc4 16bff157dc4 16bff147ec3 16bff1480c3 16bff1381c2 16bff1283c2 16bff1184c1 16bff1186c1 16bff1087c0 16bff1089c0 16bff0f8ac0 16bff0f8cbf 16bff0e8dbf 16bff0e8fbf 16bff0e90be 16bff0e92be 16bff0e93be 16bff0e95bd 16bff0e96bd 16bff0e98bd 16bff0e99bc 16bff0e9abc 16bff0e9cbc 16bff0e9dbb 16bff0e9fbb 16bff0fa0bb 16bff0fa2ba 16bff0fa3ba 16bff0fa4ba 16bff0fa6ba 16bff10a7b9 16bff10a9b9 16bff10aab9 16bff10acb8 16bff10adb8 16bff11afb7 16bff11b0b7 16bff11b1b7 16bff11b3b6 16bff11b4b6 16bff12b6b5 16bff12b7b5 16bff12b9b4 16bff12bab4 16bff12bcb3 16bff13bdb2 16bff13beb2 16bff13c0b1 16bff14c1b0 16bff14c3af 16bff15c4af 16bff15c5ae 16bff16c7ad 16bff17c8ac 16bff17caab 16bff18cbaa 16bff19cca8 16bff1acea7 16bff1ccfa6 16bff1dd0a4 16bff1ed1a3 16bff20d3a1 16bff22d4a0 16bff24d59e 16bff26d69c 16bff28d79a 16bff2ad898 16bff2cd996 16bff2fda94 16bff31db91 16bff34dc8f 16bff36dd8c 16bff39de89 16bff3cde86 16bff40df83 16bff43df80 16bff47e07d 16bff4ae079 16bff4ee076 16bff52e072 16bff56df6e 16bff5bdf6a 16bff5fde67 16bff63de63 16bff67dd5f 16bff6cdc5a 16bff70da56 16bff74d952 16bff78d84e 16bff7cd64b 16bff7fd547 16bff83d343 16bff86d240 16bff8ad03c 16bff8dce39 16bff90cc36 16bff93ca33 16bff96c830 16bff98c72d 16bff9bc52a 16bff9dc328 16bffa0c125 16bffa2bf23 16bffa4bd20 16bffa6bb1e 16bffa8b91c 16bffa9b71a 16bffabb518 16bffacb216 16bffaeb015 16bffafae13 16bffb0ac11 16bffb1aa10 16bffb3a80f 16bffb4a60d 16bffb5a40c 16bffb5a20b 16bffb6a00a 16bffb79e0a 16bffb89c09 16bffb89a08 16bffb99808 16bffba9608 16bffba9408 16bffbb9208 16bffbb9007 16bffbc8e07 16bffbc8c07 16bffbc8a07 16bffbd8808 16bffbd8608 16bffbd8408 16bffbd8208 16bffbd8008 16bffbe7e08 16bffbe7c08 16bffbe7a08 16bffbe7808 16bffbe7608 16bffbe7409 16bffbe7209 16bffbe7009 16bffbe6e09 16bffbd6c0a 16bffbd6a0a 16bffbd680a 16bffbd660b 16bffbd640b 16bffbc620c 16bffbc600c 16bffbc5e0d 16bffbb5c0d 16bffbb5a0e 16bffbb580f 16bffba560f 16bffba5410 16bffb95211 16bffb95011 16bffb84e12 16bffb84c13 16bffb74a14 16bffb74914 16bffb64715 16bffb54516 16bffb44317 16bffb44117 16bffb33f18 16bffb23d19 16bffb13b19 16bffb03a1a 16bffb0381b 16bffaf361c 16bffae341c 16bffad321d 16bffac311e 16bffab2f1e 16bffaa2d1f 16bffa92b20 16bffa72a21 16bffa62821 16bffa52622 16bffa42523 16bffa32323 16bffa12224 16bffa02025 16bff9f1e25 16bff9d1d26 16bff9c1c27 16bff9b1a27 16bff991928 16bff981728 16bff961629 16bff95152a 16bff93132a 16bff92122b 16bff90112b 16bff8f102c 16bff8d0e2d 16bff8c0d2d 16bff8a0b2e 16bff880a2e 16bff87092f 16bff85072f 16bff840630 16bff820430 16bff810330 16bff7f0231 16bff7d0131
dawnc =: 16bff2480ff 16bff2981ff 16bff2e81ff 16bff3282ff 16bff3683ff 16bff3a84ff 16bff3e85ff 16bff4186ff 16bff4487ff 16bff4787ff 16bff4a88fe 16bff4d89fe 16bff4f8afe 16bff528bfe 16bff548cfe 16bff578dfe 16bff598efe 16bff5b8efe 16bff5e8ffe 16bff6090fe 16bff6291fe 16bff6492fe 16bff6693fe 16bff6894fe 16bff6a95fe 16bff6c96fe 16bff6e96fe 16bff7097fe 16bff7298fe 16bff7499fe 16bff769afe 16bff779bfe 16bff799cfe 16bff7b9dfe 16bff7d9efe 16bff7e9ffe 16bff809ffe 16bff82a0fe 16bff83a1fe 16bff85a2fe 16bff87a3fe 16bff88a4fe 16bff8aa5fe 16bff8ba6fe 16bff8da7fe 16bff8fa8fe 16bff90a9fe 16bff92aafe 16bff93abfe 16bff95abfe 16bff96acfe 16bff98adfe 16bff99aefe 16bff9baffe 16bff9cb0fe 16bff9db1fe 16bff9fb2fe 16bffa0b3fe 16bffa2b4fe 16bffa3b5fe 16bffa5b6fe 16bffa6b7fd 16bffa7b8fd 16bffa9b9fd 16bffaabafd 16bffabbbfd 16bffadbbfd 16bffaebcfd 16bffafbdfd 16bffb1befd 16bffb2bffd 16bffb3c0fd 16bffb5c1fd 16bffb6c2fd 16bffb7c3fd 16bffb9c4fd 16bffbac5fd 16bffbbc6fd 16bffbdc7fd 16bffbec8fd 16bffbfc9fd 16bffc0cafd 16bffc2cbfd 16bffc3ccfc 16bffc4cdfc 16bffc6cefc 16bffc7cffc 16bffc8d0fc 16bffc9d1fc 16bffcbd2fc 16bffccd3fc 16bffcdd4fc 16bffced5fc 16bffcfd6fc 16bffd1d7fc 16bffd2d8fc 16bffd3d9fc 16bffd4dafc 16bffd6dbfc 16bffd7dcfc 16bffd8ddfb 16bffd9defb 16bffdadffb 16bffdce0fb 16bffdde1fb 16bffdee2fb 16bffdfe3fb 16bffe0e4fb 16bffe2e5fb 16bffe3e6fb 16bffe4e7fb 16bffe5e8fb 16bffe6e9fb 16bffe7eafb 16bffe9ebfa 16bffeaecfa 16bffebedfa 16bffeceefa 16bffedeffa 16bffeef0fa 16bfff0f1fa 16bfff1f2fa 16bfff2f3fa 16bfff3f4fa 16bfff4f5f9 16bfff5f6f9 16bfff7f6f9 16bfff8f7f8 16bfff9f6f7 16bfff9f6f5 16bfffaf5f4 16bfffaf4f2 16bfffaf2f0 16bfffbf1ef 16bfffbf0ed 16bfffbefec 16bfffbedea 16bfffcece8 16bfffcebe7 16bfffceae5 16bfffce8e3 16bfffce7e2 16bfffce6e0 16bfffce5df 16bfffde3dd 16bfffde2db 16bfffde1da 16bfffddfd8 16bfffdded7 16bfffdddd5 16bfffddcd3 16bfffddad2 16bfffdd9d0 16bfffdd8cf 16bfffed7cd 16bfffed5cb 16bfffed4ca 16bfffed3c8 16bfffed2c7 16bfffed0c5 16bfffecfc3 16bfffecec2 16bfffecdc0 16bfffecbbf 16bfffecabd 16bfffec9bc 16bfffec7ba 16bfffec6b9 16bfffec5b7 16bfffec4b5 16bfffec2b4 16bfffec1b2 16bfffdc0b1 16bfffdbfaf 16bfffdbdae 16bfffdbcac 16bfffdbbab 16bfffdbaa9 16bfffdb8a7 16bfffdb7a6 16bfffdb6a4 16bfffdb4a3 16bfffdb3a1 16bfffcb2a0 16bfffcb19e 16bfffcaf9d 16bfffcae9b 16bfffcad9a 16bfffcac98 16bfffcaa97 16bfffba995 16bfffba894 16bfffba692 16bfffba591 16bfffba48f 16bfffba38e 16bfffaa18c 16bfffaa08b 16bfffa9f89 16bfffa9e88 16bfff99c86 16bfff99b85 16bfff99a83 16bfff99882 16bfff99780 16bfff8967f 16bfff8947d 16bfff8937c 16bfff8927a 16bfff79179 16bfff78f77 16bfff78e76 16bfff68d74 16bfff68b73 16bfff68a71 16bfff68970 16bfff5876e 16bfff5866d 16bfff5856b 16bfff4836a 16bfff48269 16bfff48167 16bfff37f66 16bfff37e64 16bfff37d63 16bfff27b61 16bfff27a60 16bfff2795e 16bfff1775d 16bfff1765c 16bfff1755a 16bfff07359 16bfff07257 16bfff07156 16bffef6f54 16bffef6e53 16bffee6c52 16bffee6b50 16bffee6a4f 16bffed684d 16bffed674c 16bffec654a 16bffec6449 16bffec6248 16bffeb6146 16bffeb6045 16bffea5e43 16bffea5d42 16bffe95b41 16bffe95a3f 16bffe9583e 16bffe8573c 16bffe8553b 16bffe7533a 16bffe75238 16bffe65037
aquac =: |. 16bffeaffff 16bffe9fefe 16bffe8fdfd 16bffe7fcfc 16bffe6fbfb 16bffe5fafa 16bffe4fafa 16bffe3f9f9 16bffe2f8f8 16bffe1f7f7 16bffe0f6f6 16bffdff5f5 16bffdef5f5 16bffdef4f4 16bffddf3f3 16bffdcf2f2 16bffdbf1f1 16bffdaf0f0 16bffd9f0f0 16bffd8efef 16bffd7eeee 16bffd6eded 16bffd5ecec 16bffd4ebeb 16bffd3ebeb 16bffd3eaea 16bffd2e9e9 16bffd1e8e8 16bffd0e7e7 16bffcfe6e6 16bffcee6e6 16bffcde5e5 16bffcce4e4 16bffcbe3e3 16bffcae2e2 16bffc9e1e1 16bffc8e1e1 16bffc8e0e0 16bffc7dfdf 16bffc6dede 16bffc5dddd 16bffc4dcdc 16bffc3dcdc 16bffc2dbdb 16bffc1dada 16bffc0d9d9 16bffbfd8d8 16bffbed7d7 16bffbdd7d7 16bffbdd6d6 16bffbcd5d5 16bffbbd4d4 16bffbad3d3 16bffb9d2d2 16bffb8d2d2 16bffb7d1d1 16bffb6d0d0 16bffb5cfcf 16bffb4cece 16bffb3cdcd 16bffb2cdcd 16bffb2cccc 16bffb1cbcb 16bffb0caca 16bffafc9c9 16bffaec8c8 16bffadc8c8 16bffacc7c7 16bffabc6c6 16bffaac5c5 16bffa9c4c4 16bffa8c3c3 16bffa7c3c3 16bffa7c2c2 16bffa6c1c1 16bffa5c0c0 16bffa4bfbf 16bffa3bebe 16bffa2bebe 16bffa1bdbd 16bffa0bcbc 16bff9fbbbb 16bff9ebaba 16bff9db9b9 16bff9cb9b9 16bff9cb8b8 16bff9bb7b7 16bff9ab6b6 16bff99b5b5 16bff98b5b5 16bff97b4b4 16bff96b3b3 16bff95b2b2 16bff94b1b1 16bff93b0b0 16bff92b0b0 16bff91afaf 16bff90aeae 16bff90adad 16bff8facac 16bff8eabab 16bff8dabab 16bff8caaaa 16bff8ba9a9 16bff8aa8a8 16bff89a7a7 16bff88a6a6 16bff87a6a6 16bff86a5a5 16bff85a4a4 16bff85a3a3 16bff84a2a2 16bff83a1a1 16bff82a1a1 16bff81a0a0 16bff809f9f 16bff7f9e9e 16bff7e9d9d 16bff7d9c9c 16bff7c9c9c 16bff7b9b9b 16bff7a9a9a 16bff7a9999 16bff799898 16bff789797 16bff779797 16bff769696 16bff759595 16bff749494 16bff739393 16bff729292 16bff719292 16bff709191 16bff6f9090 16bff6f8f8f 16bff6e8e8e 16bff6d8d8d 16bff6c8d8d 16bff6b8c8c 16bff6a8b8b 16bff698a8a 16bff688989 16bff678888 16bff668888 16bff658787 16bff648686 16bff648585 16bff638484 16bff628383 16bff618383 16bff608282 16bff5f8181 16bff5e8080 16bff5d7f7f 16bff5c7e7e 16bff5b7e7e 16bff5a7d7d 16bff597c7c 16bff597b7b 16bff587a7a 16bff577979 16bff567979 16bff557878 16bff547777 16bff537676 16bff527575 16bff517474 16bff507474 16bff4f7373 16bff4e7272 16bff4e7171 16bff4d7070 16bff4c7070 16bff4b6f6f 16bff4a6e6e 16bff496d6d 16bff486c6c 16bff476b6b 16bff466b6b 16bff456a6a 16bff446969 16bff436868 16bff426767 16bff426666 16bff416666 16bff406565 16bff3f6464 16bff3e6363 16bff3d6262 16bff3c6161 16bff3b6161 16bff3a6060 16bff395f5f 16bff385e5e 16bff375d5d 16bff375c5c 16bff365c5c 16bff355b5b 16bff345a5a 16bff335959 16bff325858 16bff315757 16bff305757 16bff2f5656 16bff2e5555 16bff2d5454 16bff2c5353 16bff2c5252 16bff2b5252 16bff2a5151 16bff295050 16bff284f4f 16bff274e4e 16bff264d4d 16bff254d4d 16bff244c4c 16bff234b4b 16bff224a4a 16bff214949 16bff214848 16bff204848 16bff1f4747 16bff1e4646 16bff1d4545 16bff1c4444 16bff1b4343 16bff1a4343 16bff194242 16bff184141 16bff174040 16bff163f3f 16bff163e3e 16bff153e3e 16bff143d3d 16bff133c3c 16bff123b3b 16bff113a3a 16bff103939 16bff0f3939 16bff0e3838 16bff0d3737 16bff0c3636 16bff0b3535 16bff0b3434 16bff0a3434 16bff093333 16bff083232 16bff073131 16bff063030 16bff052f2f 16bff042f2f 16bff032e2e 16bff022d2d 16bff012c2c 16bff002b2b 16bff002b2b
greyc =: 16bff1b1b1b 16bff1c1c1c 16bff1d1d1d 16bff1d1d1d 16bff1e1e1e 16bff1f1f1f 16bff1f1f1f 16bff202020 16bff212121 16bff222222 16bff222222 16bff232323 16bff242424 16bff242424 16bff252525 16bff262626 16bff262626 16bff272727 16bff282828 16bff282828 16bff292929 16bff2a2a2a 16bff2b2b2b 16bff2b2b2b 16bff2c2c2c 16bff2d2d2d 16bff2d2d2d 16bff2e2e2e 16bff2f2f2f 16bff303030 16bff303030 16bff313131 16bff323232 16bff323232 16bff333333 16bff343434 16bff353535 16bff353535 16bff363636 16bff373737 16bff383838 16bff383838 16bff393939 16bff3a3a3a 16bff3b3b3b 16bff3b3b3b 16bff3c3c3c 16bff3d3d3d 16bff3e3e3e 16bff3e3e3e 16bff3f3f3f 16bff404040 16bff414141 16bff414141 16bff424242 16bff434343 16bff444444 16bff444444 16bff454545 16bff464646 16bff474747 16bff474747 16bff484848 16bff494949 16bff4a4a4a 16bff4a4a4a 16bff4b4b4b 16bff4c4c4c 16bff4d4d4d 16bff4e4e4e 16bff4e4e4e 16bff4f4f4f 16bff505050 16bff515151 16bff515252 16bff525252 16bff535353 16bff545454 16bff555555 16bff555555 16bff565656 16bff575757 16bff585858 16bff595959 16bff595959 16bff5a5a5a 16bff5b5b5b 16bff5c5c5c 16bff5d5d5d 16bff5d5d5d 16bff5e5e5e 16bff5f5f5f 16bff606060 16bff616161 16bff616161 16bff626262 16bff636363 16bff646464 16bff656565 16bff666666 16bff666666 16bff676767 16bff686868 16bff696969 16bff6a6a6a 16bff6a6a6a 16bff6b6b6b 16bff6c6c6c 16bff6d6d6d 16bff6e6e6e 16bff6f6f6f 16bff6f6f6f 16bff707070 16bff717171 16bff727272 16bff737373 16bff747474 16bff747474 16bff757575 16bff767676 16bff777777 16bff787878 16bff797979 16bff797979 16bff7a7a7a 16bff7b7b7b 16bff7c7c7c 16bff7d7d7d 16bff7e7e7e 16bff7e7f7f 16bff7f7f7f 16bff808080 16bff818181 16bff828282 16bff838383 16bff848484 16bff848484 16bff858585 16bff868686 16bff878787 16bff888888 16bff898989 16bff8a8a8a 16bff8a8a8a 16bff8b8b8b 16bff8c8c8c 16bff8d8d8d 16bff8e8e8e 16bff8f8f8f 16bff909090 16bff919191 16bff919191 16bff929292 16bff939393 16bff949494 16bff959595 16bff969696 16bff979797 16bff989898 16bff989898 16bff999999 16bff9a9a9a 16bff9b9b9b 16bff9c9c9c 16bff9d9d9d 16bff9e9e9e 16bff9f9f9f 16bff9f9f9f 16bffa0a0a0 16bffa1a1a1 16bffa2a2a2 16bffa3a3a3 16bffa4a4a4 16bffa5a5a5 16bffa6a6a6 16bffa7a7a7 16bffa7a7a7 16bffa8a8a8 16bffa9a9a9 16bffaaaaaa 16bffababab 16bffacacac 16bffadadad 16bffaeaeae 16bffafafaf 16bffb0b0b0 16bffb0b0b0 16bffb1b1b1 16bffb2b2b2 16bffb3b3b3 16bffb4b4b4 16bffb5b5b5 16bffb6b6b6 16bffb7b7b7 16bffb8b8b8 16bffb9b9b9 16bffb9baba 16bffbababa 16bffbbbbbb 16bffbcbcbc 16bffbdbdbd 16bffbebebe 16bffbfbfbf 16bffc0c0c0 16bffc1c1c1 16bffc2c2c2 16bffc3c3c3 16bffc4c4c4 16bffc4c4c4 16bffc5c5c5 16bffc6c6c6 16bffc7c7c7 16bffc8c8c8 16bffc9c9c9 16bffcacaca 16bffcbcbcb 16bffcccccc 16bffcdcdcd 16bffcecece 16bffcfcfcf 16bffd0d0d0 16bffd0d1d1 16bffd1d1d1 16bffd2d2d2 16bffd3d3d3 16bffd4d4d4 16bffd5d5d5 16bffd6d6d6 16bffd7d7d7 16bffd8d8d8 16bffd9d9d9 16bffdadada 16bffdbdbdb 16bffdcdcdc 16bffdddddd 16bffdedede 16bffdfdfdf 16bffdfe0e0 16bffe0e0e0 16bffe1e1e1 16bffe2e2e2 16bffe3e3e3 16bffe4e4e4 16bffe5e5e5 16bffe6e6e6 16bffe7e7e7 16bffe8e8e8 16bffe9e9e9 16bffeaeaea 16bffebebeb 16bffececec 16bffededed 16bffeeeeee 16bffefefef 16bfff0f0f0 16bfff1f1f1

NB. Min width height of viewmat.
MINWH_VIEW =: 512 512
NB. Min width height of colorbar.
MINH_COLORBAR =: 400
NB. Used in repaint when drawing colorbar.
colorbar =: i. 256 1
NB. Create and destroy must be declared. 
create =: 0:
destroy =: codestroy

viewmax =: {{)v
EMPTY viewmax y
:
loc =. '' conew 'jviewmax'

NB. If colormap was specified by user.
if. 0 < # x do.
  NB. Check if colormap is correctly specified.
  if. (256 >: {. $ x) *. (3 = {: $ x) *. 2 = # $ x do.
    NB. Colormap in x must have 256 elements, so shorten or lengthen it of necessary.
    x256 =. 256 1 fitvm ,: 256 #. 255 ,. x
    NB. x256 has shape 1 256, so {. x256 to get shape 256.
    ({. x256) viewmaxRun__loc y
  else.
    sminfo 'Wrong shape of colormap: ' , (": $ x) , '. Expected rgb format: rank 2, shape (n 3) where n <= 256, values in [0; 255].'
  end.
else.
  EMPTY viewmaxRun__loc y
end.
EMPTY
}}

NB. Extract 2D slice from array.
getSlice =: ({~ <)~

NB. Main viewmax verb.
viewmaxRun =: {{
NB. Parse x (set user's custom colormap if specified).
userc =: x
NB. Parse y.
NB. Title is optional (default is 'viewmax').
'array customTitle' =. 2 {. boxopen y
customTitle =. ": customTitle
title =: customTitle , (0 = # customTitle) # 'viewmax'
NB. Check shape.
if. 0 = */ $ array do.
  sminfo 'Array with shape ' , (": $ array) , ' has 0 elements. Nothing to view.'
  EMPTY return.
end.
NB. Support all numeric types.
if. -. (3!:0 array) e. 1 4 16 64 128 8 6 7 11 do.
  sminfo 'Data type not supported: ' , datatype array , '.'
  EMPTY return.
end.
NB. Do not support NaN.
if. +./ 128!:5 , array do.
  sminfo 'Data contains NaN.'
  EMPTY return.
end.
NB. Do not support Infinity.
if. +./ _ = , | array do.
  sminfo 'Data contains infinity.'
  EMPTY return.
end.
NB. Define VMH if not defined (see verb closeall below).
if. 0 > nc < 'VMH' do. setvmh '' end.
NB. Set matrix info.
NB. If rank < 2 then itemize.
matrix =: ,:^:(0 >. 2 - # $ array) array
dataType =: datatype matrix
if. dataType -: 'complex' do.
   matrixAngles =: * matrix
   matrix =: {.&.|: *. matrix
end.
shape =. $ matrix
rank =: # shape
minVal =: <./ , matrix
maxVal =: >./ , matrix
NB. Displayed dimensions.
viewdim1 =: 0
viewdim2 =: 1
viewdetails =: (2 $ < a:) , (rank - 2) $ < 0
NB. Colormap.
if. userc -: EMPTY do.
  colormap =: turboc
  defaultColormap =: 'turbo'
else.
  colormap =: userc
  defaultColormap =: 'customcolormap'
end.
NB. Is slice transposed? It is value of checkbox "Transpose".
transposition =: 0
NB. Normalization of colors (0 means use all colors in slice, 1 means colors scaled to all values in matrix). It is value of checkbox "Scale to all".
normalization =: 1
NB. Can draw? Exactly two checkboxes are set.
dodraw =: 1
NB. normic is scaled matrix to [0; 255].
if. minVal = maxVal do. NB. Avoid division by 0 when constant matrix.
  normic =: <. (matrix - minVal) + 127 NB. Middle of the scale.
else.
  normic =: <. 255 * (matrix - minVal) % maxVal - minVal NB. Colormaps have 256 color levels.
end.
NB. Is checkbox "Keep aspect ratio" selected?
aspectratio =: 0
NB. 2D matrix representing slice.
data =: viewdetails getSlice normic
if. dataType -: 'complex' do.
   dataAngles =: viewdetails getSlice matrixAngles
end.
NB. Scale slice.
'rows cols' =. $ data
ratio =. cols % rows

if. ratio > 1 do.
  cols =. {: MINWH_VIEW
  rows =. <. cols % ratio
else.
  rows =. {. MINWH_VIEW
  cols =. <. rows * ratio
end.
NB. Wd commands (user interface).
viewPanel =. 'pc viewmax closeok closebutton; pn "' , title , '"; bin v; splitv;bin hg;grid shape 2;grid colstretch 0 1; groupbox "Slice view";minwh ' , (": cols) , ' ' , (": rows) , '; cc view isidraw;groupboxend;groupbox "Color bar";bin h; minwh 40 ' , (": MINH_COLORBAR) , ';grid shape 1 2; cc colorbar isidraw;bin v; cc maximl static center nowrap; cn "0"; bin s2; cc miniml static center nowrap; cn "0"; bin z; bin z;groupboxend;bin z;splitsep;'
footer =. 'bin z;splitend;bin z;cc status statusbar ;set status addlabel dims;set status setlabel dims "Rank: ' , (": rank) , ', Shape: ' , (": $ array) , '"; pshow'
dataRepresentation =. 'bin h; bin v;groupbox "Display parameters"; cc aspect checkbox; cn keep aspect ratio; cc transpose checkbox; cc normalizeall checkbox; cn scale to all;set normalizeall value 1; groupboxend; bin z;'
colormapPanel =. 'groupboxend;bin z; bin v ;groupbox "Colormap"; ' , (';cc customcolormap radiobutton; cn "custom"'"_^:(-. userc -: EMPTY) '') , ';cc turbo radiobutton ;cn "turbo jet";set ' , defaultColormap , ' value 1;cc mist radiobutton ;cn "dusk mist";cc dawn radiobutton ;cc aqua radiobutton ;cc smoke radiobutton; groupboxend;bin z; bin z;'
NB. Draw sliders if rank > 2.
if. rank > 2 do.
  slicePositionPanel =. 'bin vhg;groupbox "Slice position (select two axes)"; grid shape ' , (": rank) ,' 4;grid colwidth 1 50; '
  for_d. i. 2 do.
    nr =. ": d
    slicePositionPanel =. slicePositionPanel , 'grid rowheight d 1;cc ln' , nr , ' static center nowrap; cn ',nr,'; cc c' , nr , ' checkbox;set c' , nr , ' value 1; cn "";cc s' , nr , ' slider; set s' , nr , ' min 0; set s' , nr , ' max ' , (": d { <: shape) , '; set s' , nr , ' step 1; cc l' , nr , ' static center nowrap; cn "0"; set s' , nr , ' visible 0; set l' , nr , ' visible 0;'
  end.
else.
  slicePositionPanel =. 'bin h;groupbox "Slice position"; cc l2d static center nowrap; cn "Full view of matrix"; set normalizeall visible 0;'
end.
for_d. 2 + i. rank - 2 do.
  nr =. ": d
  slicePositionPanel =. slicePositionPanel , 'grid rowheight d 1; cc ln' , nr , ' static center nowrap; cn ', nr, '; cc c' , nr , ' checkbox; set c' , nr , ' value 0; cn "";cc s' , nr , ' slider ; set s' , nr , ' min 0; set s' , nr , ' max ', (": d { <: shape) , '; set s' , nr , ' step 1; cc l' , nr , ' static center nowrap; cn "0";'
end.
wd viewPanel , dataRepresentation , slicePositionPanel , colormapPanel , footer
for_d. i. rank do.
  nr =. ": d
  ". 'viewmax_s' , nr , '_changed =: {{ viewmax_change_slice ' , nr , '}}'
  ". 'viewmax_c' , nr , '_button =: {{ viewmax_change_checkbox ' , nr , ' }}'
end.
repaint ''
}}

setSliceAndScale =: {{
if. normalization do.
  data =: viewdetails getSlice normic
else.
  dataNotNormalized =: viewdetails getSlice matrix
  minValNotNormalized =: <./ , dataNotNormalized
  maxValNotNormalized =: >./, dataNotNormalized
  if. minValNotNormalized = maxValNotNormalized do.
    dataNotNormalized =: <. (dataNotNormalized - minValNotNormalized) + 127
  else.
    dataNotNormalized =: <. 255 * (dataNotNormalized - minValNotNormalized) % maxValNotNormalized - minValNotNormalized
  end.
end.
}}

updateDodraw =: {{
if. 2 = +/ viewdetails = < a: do. NB. Exactly two checkboxes set means we can draw.
  dodraw =: 1
  setSliceAndScale normalization
  if. dataType -: 'complex' do.
     dataAngles =: viewdetails getSlice matrixAngles
  end.
else.
  dodraw =: 0
end.
}}

NB. Slider to change slice handler.
viewmax_change_slice =: {{
wd 'set l' , (": y) , ' text ' , ". 's' , ": y
viewdetails =: (< ". ". 's', ": y) y} viewdetails
updateDodraw ''
repaint ''
}}

NB. Checkbox of selected axes handler.
viewmax_change_checkbox =: {{
checkboxVal =. ". 'c' , ": y
if. 1 = ". checkboxVal do. NB. It has just been turned on.
  if. (viewdim1 >: 0) *. viewdim2 >: 0 do. NB. Two checkboxes are already set (too many, because max is 2).
    wd 'set c' , (": viewdim2) , ' value 0'
    wd 'set s' , (": viewdim2) , ' visible 1'
    wd 'set l' , (": viewdim2) , ' visible 1'
    wd 'set s' , (": y) , ' visible 0'
    wd 'set l' , (": y) , ' visible 0'

    viewdetails =: (< ". ". 's' , ": viewdim2) viewdim2} viewdetails
    viewdim2 =: y
    viewdetails =: (< a:) y} viewdetails
  else. NB. At most one checkbox is already set.
    wd 'set s' , (": y) , ' visible 0'
    wd 'set l' , (": y) , ' visible 0'

    if. viewdim1 < 0 do.
      viewdim1 =: y
    else.
      viewdim2 =: y
    end.

    viewdetails =: (< a:) y} viewdetails
  end.
else. NB. It has just been turned off.
  wd 'set s' , (": y) , ' visible 1'
  wd 'set l' , (": y) , ' visible 1'
  viewdetails =: (< ". ". 's' , ": y) y} viewdetails

  if. viewdim1 = y do.
    viewdim1 =: _1
  else.
    viewdim2 =: _1
  end.
end.

updateDodraw ''
repaint ''
}}

NB. Repaint when window is resized.
viewmax_view_resize =: {{
repaint ''
}}

NB. Keep aspect ratio handler.
viewmax_aspect_button =: {{
aspectratio =: -. aspectratio
repaint ''
}}

NB. Transpose button handler.
viewmax_transpose_button =: {{
transposition =: ". transpose
repaint ''
}}

NB. Scale to all button handler.
viewmax_normalizeall_button =: {{
normalization =: ". normalizeall
setSliceAndScale normalization
repaint ''
}}

NB. Colormap buttons handlers.

viewmax_turbo_button =: {{
colormap =: turboc
repaint ''
}}

viewmax_aqua_button =: {{
colormap =: aquac
repaint ''
}}

viewmax_mist_button =: {{
colormap =: mistc
repaint ''
}}

viewmax_smoke_button =: {{
colormap =: greyc
repaint ''
}}

viewmax_dawn_button =: {{
colormap =: dawnc
repaint ''
}}

viewmax_customcolormap_button =: {{
colormap =: userc
repaint ''
}}

NB. Scale matrix (magnifing glass).
fitvm =: {{)d
'w h' =. x
mat =. y
'r c' =. $ mat
exp =. (- 0: , }:) <. 0.5 + +/\ r $ h % r
mat =. exp # mat
exp =. (- 0: , }:) <. 0.5 + +/\ c $ w % c
exp #"1 mat
}}

paintPixelMatrix =: 0 0&$: : (glpaint@:glpixels@:(, (|.@:$ , ,)))

roundToInt =: <.@:+&0.5

repaint =: {{
if. dodraw do.
  glsel 'view'
  NB. Width, height of panel with matrix.
  widthHeight =. glqwh ''
  'width height' =. widthHeight
  NB. Shape of matrix.
  'rows cols' =. |.^:transposition $ data
  NB. Update width, heigth if keep aspect ratio.
  if. aspectratio do.
    ratio =. cols % rows
    if. ratio > width % height do.
      newWidth =: width
      newHeight =: rows * width % cols
    else.
      newHeight =: height
      newWidth =: cols * height % rows
    end.
    widthHeight =. newWidth , newHeight
  end.
  if. dataType -: 'complex' do.
   matAng =: |:^:transposition dataAngles
  end.
  if. normalization do.
    mat =. widthHeight fitvm |:^:transposition data
  else.
    mat =. widthHeight fitvm |:^:transposition dataNotNormalized
  end.
  NB. White background with dotted border (visible when keep aspect ratio).
  glrgba 255 255 255 255
  glfill 255 255 255 255
  glpen 1 3
  glbrush ''
  glrect 0 , 0 , width , height
  NB. Draw slice.
  if. aspectratio do.
    ((2%~ width - newWidth) , 2%~ height - newHeight) paintPixelMatrix mat { colormap
  else.
    paintPixelMatrix mat { colormap
  end.
  NB. Draw arrows when complex numbers.
  if. dataType -: 'complex' do.
    NB. Arrow big (outer white arrow).
    arrowBig =.  _15j_10 _5 _15j10 15 
    NB. Arrow small (inner black arrow).
    arrowSmall =.  _9j_6 _3 _9j6 9 
    NB. Arrows are centered in (0, 0) to simplify rotations.
    NB. scls is height of single element of slice.
    NB. srws is width of single element of slice.
    NB. len is minimum from scls and srws.
    NB. len is used to compute arrow size (fit arrow into matrix element).
    len =. <. <./ 'scls srws' =. widthHeight % cols , rows
    NB. xm, ym are coordinates of centers of matrix elements.
    if. aspectratio do. 
       xm =. (2%~ width - newWidth) + (-: scls) + scls * i. cols 
       ym =. (2%~ height - newHeight)+ (-: srws) + srws * i. rows
    else. 
       xm =. (-: scls) + scls * i. cols
       ym =. (-: srws) + srws * i. rows
    end.
    NB. Mid is xm ym as complex numbers.
    mid =. xm j."1 0 ym
    NB. Draw arrows.
    NB. White outer arrow.
    glrgba 255 255 255 255
    glpen 1 1
    glbrush''
    glpolygon _8 [\ , roundToInt +."1 mid + + matAng */ 60 %~ len * arrowBig
    NB. Black inner arrow.
    glrgba 0 0 0 255
    glpen 1 1
    glbrush''
    glpolygon _8 [\ , roundToInt +."1 mid + + matAng */ 60 %~ len * arrowSmall
    glrgba 255 255 255 255
    glpen 1 1
    glbrush''
  end.
  NB. Draw color bar.
  glsel 'colorbar'
  'widthColorbar heightColorbar' =. widthHeightColorbar =. glqwh ''
  mat =. widthHeightColorbar fitvm colorbar
  paintPixelMatrix mat { |. colormap
  NB. Min and max values.
  if. normalization do.
    wd 'set miniml text ' , ": minVal
    wd 'set maximl text ' , ": maxVal
  else.
    wd 'set miniml text ' , ": minValNotNormalized
    wd 'set maximl text ' , ": maxValNotNormalized
  end.
  NB. Draw borders of used color range in color bar.
  NB. Only when normalization (without normalization whole color range is used in current slice). 
  if. normalization *. rank > 2 do.
    y1 =. <. heightColorbar - 4 + heightColorbar * 255 %~ <./ , data
    y2 =. <. heightColorbar - (heightColorbar * 255 %~ >./ , data) - 4
    glrgb 254 254 254
    glpen 5 3
    gllines 10 , y1 , 30 , y1
    gllines 10 , y2 , 30 , y2
    glrgb 1 1 1
    glpen 3 3
    gllines 10 , y1 , 30 , y1
    gllines 10 , y2 , 30 , y2
  end.
else. NB. Not enough axes specified (less than 2 checkboxes are set).
  NB. Print message in place of slice.
  glsel 'view'
  'width height' =: glqwh ''
  glrgba 128 10 10 255
  glfill 255 255 255 255
  glrect 0 , 0 , width , height
  glrgba 255 0 0 255
  glpen 1 3
  gltextxy 10 10
  gltextcolor ''
  gltext 8 u: 'Set two checkboxes (two axes must be specified)!'
end.
hadd ''
glpaint ''
}}

NB. Keypress handlers.
NB. Ctrl+J for labs. 
viewmax_jctrl_fkey =: {{ lab_jlab_ 0 }}
NB. Ctrl+S for saving the slice.
NB. When script run from Edit window the user has to focus on Term first.
NB. Then saving slice in focused viewmax window should work.
viewmax_sctrl_fkey =: {{
path =. jpath '~temp/' , title , '.png'
(getbitmap '') writepng path
}}

getbitmap =: {{
glsel 'view'
NB. If aspect ratio then we don't want to save empty space, only the slice.
if. aspectratio do. 
  'width height' =. glqwh ''
  leftUpperX =. <. 2%~ width - newWidth
  leftUpperY =. <. 2%~ height - newHeight
  box =. leftUpperX , leftUpperY , (<. newWidth) , <. newHeight
else.
  box =. 0 0 , glqwh ''
end.
res =. glqpixels box
(3 2 { box) $ res
}}

NB. Ctrl+Esc for closing viewmax window.
viewmax_key_press =: {{
if. isesckey y do. 
  viewmat_close ''
else. 
  0 
end.
}}
NB. Verbs for closing single viewmax window.
viewmax_close =: {{
hremove ''
wd 'psel ' , syshwndp , '; pclose'
destroy ''
1
}}

window_delete =: viewmax_cancel =: viewmax_close

viewmax_quit_button =: wd bind 'pclose'

NB. Verbs from original viewmat for verb closeall.
NB. Track opened windows to close all of them on request. 
NB. hadd, hremove, hforms verbs starts with letter h (habitant?).

intersect =: e. # [

hadd =: {{
setvmh VMH ,~ coname ''
}}

hforms =: {{
fms =. <;._2 &> <;._2 wdqpx''
if. 0 = # fms do. EMPTY return. end.
fms =. fms #~ (2{"1 fms) e. VMH
if. 0 = # fms do. EMPTY return. end.
fms \: 0 ". &> 4{"1 fms
}}

hremove =: {{
setvmh VMH -. coname ''
}}

setvmh =: {{
VMH_jviewmax_ =: (~. y) intersect conl 1
}}

closeall =: {{
for_fm. hforms'' do.
  id =. > 1 { fm
  loc =. 2 { fm
  hremove__loc ''
  wd 'psel ' , id , ';pclose'
  destroy__loc''
end.
}}

viewmax_z_ =: viewmax_jviewmax_

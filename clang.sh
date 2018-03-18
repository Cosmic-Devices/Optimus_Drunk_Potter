#!/bin/bash

DATE_POSTFIX=$(date +"%Y%m%d")

KERNEL_DIR=$PWD
KERNEL_DEFCONFIG=potter_defconfig
DTBTOOL=$KERNEL_DIR/Dtbtool/
ANY_KERNEL2_DIR=$KERNEL_DIR/AnyKernel2/
FINAL_KERNEL_ZIP=Optimus_Drunk_Potter-$DATE_POSTFIX.zip
#CCACHE=$(command -v ccache)
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-android-"
export TOOL_CHAIN_PATH="/home/gtrcraft/data/validus/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin"
export CLANG_TCHAIN="/home/gtrcraft/data/kernel/clang/clang-4579689/bin/clang"
export LD_LIBRARY_PATH="${TOOL_CHAIN_PATH}/../lib"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export KBUILD_COMPILER_STRING="clang version 6.0.1"

kmake() {
	        make CC="${CLANG_TCHAIN}" \
			             CLANG_TRIPLE=aarch64-linux-android- \
				                  CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE} \
						               HOSTCC="${CLANG_TCHAIN}" \
							                    $@
	}

	clean () {
		        kmake clean && kmake mrproper
		}

		compile() {
			        kmake $KERNEL_DEFCONFIG
				        kmake -j16
				}

				DTB () {
					        $DTBTOOL/dtbToolCM -2 -o $KERNEL_DIR/arch/arm/boot/dtb -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/qcom/
					}

					AnyKernel () {
						        ls $ANY_KERNEL2_DIR
							        rm -rf $ANY_KERNEL2_DIR/dtb
								        rm -rf $ANY_KERNEL2_DIR/Image.gz
									        rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
										        cp $KERNEL_DIR/arch/arm64/boot/Image.gz $ANY_KERNEL2_DIR/
											        cp $KERNEL_DIR/arch/arm/boot/dtb $ANY_KERNEL2_DIR/
												        cd $ANY_KERNEL2_DIR/
													        zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
														        rm -rf /home/gtrcraft/data/kernel/$FINAL_KERNEL_ZIP
															        cp $KERNEL_DIR/AnyKernel2/$FINAL_KERNEL_ZIP /home/gtrcraft/data/kernel/$FINAL_KERNEL_ZIP
															}

															GoodBye () {
																        cd $KERNEL_DIR
																	        rm -rf arch/arm/boot/dtb
																		        rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
																			        rm -rf AnyKernel2/Image.gz
																				        rm -rf AnyKernel2/dtb
																				}
																				clean
																				compile
																				DTB
																				AnyKernel
																				GoodBye

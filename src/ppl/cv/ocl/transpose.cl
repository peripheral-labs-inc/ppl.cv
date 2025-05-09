/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with this
 * work for additional information regarding copyright ownership. The ASF
 * licenses this file to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

#if defined(TRANSPOSE_U8C1) || defined(ALL_KERNELS)
__kernel
void transposeU8C1Kernel(global const uchar* src, int rows, int cols,
                         int src_stride, global uchar* dst, int dst_stride) {
  int element_x = get_global_id(0);
  int element_y = get_global_id(1);
  int index_x = element_x * 4, index_y = element_y * 4;
  if (index_x >= cols || index_y >= rows) {
    return;
  }
  src = (global const uchar*)((uchar*)src + index_y * src_stride);
  int remain_cols = cols - index_x, remain_rows = rows - index_y;
  uchar4 input_value[4];
  for (int i = 0; i < min(remain_rows, 4); i++) {
    input_value[i] = vload4(element_x, src);
    src = (global const uchar*)((uchar*)src + src_stride);
  }
  dst = (global uchar*)((uchar*)dst + dst_stride * index_x);
  if (remain_rows >= 4) {
    if (remain_cols >= 4) {
      uchar4 output_value[4];
      output_value[0] = (uchar4)(input_value[0].x, input_value[1].x,
                                 input_value[2].x, input_value[3].x);
      output_value[1] = (uchar4)(input_value[0].y, input_value[1].y,
                                 input_value[2].y, input_value[3].y);
      output_value[2] = (uchar4)(input_value[0].z, input_value[1].z,
                                 input_value[2].z, input_value[3].z);
      output_value[3] = (uchar4)(input_value[0].w, input_value[1].w,
                                 input_value[2].w, input_value[3].w);
      for (int k = 0; k < 4; k++) {
        vstore4(output_value[k], element_y, dst);
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 1) {
      uchar4 output_value[1];
      output_value[0] = (uchar4)(input_value[0].x, input_value[1].x,
                                 input_value[2].x, input_value[3].x);
      for (int k = 0; k < 1; k++) {
        vstore4(output_value[k], element_y, dst);
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 2) {
      uchar4 output_value[2];
      output_value[0] = (uchar4)(input_value[0].x, input_value[1].x,
                                 input_value[2].x, input_value[3].x);
      output_value[1] = (uchar4)(input_value[0].y, input_value[1].y,
                                 input_value[2].y, input_value[3].y);
      for (int k = 0; k < 2; k++) {
        vstore4(output_value[k], element_y, dst);
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 3) {
      uchar4 output_value[3];
      output_value[0] = (uchar4)(input_value[0].x, input_value[1].x,
                                 input_value[2].x, input_value[3].x);
      output_value[1] = (uchar4)(input_value[0].y, input_value[1].y,
                                 input_value[2].y, input_value[3].y);
      output_value[2] = (uchar4)(input_value[0].z, input_value[1].z,
                                 input_value[2].z, input_value[3].z);
      for (int k = 0; k < 3; k++) {
        vstore4(output_value[k], element_y, dst);
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
  }
  else if (remain_rows == 1) {
    if (remain_cols >= 4) {
      uchar output_value[4];
      output_value[0] = (uchar)(input_value[0].x);
      output_value[1] = (uchar)(input_value[0].y);
      output_value[2] = (uchar)(input_value[0].z);
      output_value[3] = (uchar)(input_value[0].w);
      for (int k = 0; k < 4; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k];
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 1) {
      uchar output_value[1];
      output_value[0] = (uchar)(input_value[0].x);
      for (int k = 0; k < 1; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k];
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 2) {
      uchar output_value[2];
      output_value[0] = (uchar)(input_value[0].x);
      output_value[1] = (uchar)(input_value[0].y);
      for (int k = 0; k < 2; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k];
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 3) {
      uchar output_value[3];
      output_value[0] = (uchar)(input_value[0].x);
      output_value[1] = (uchar)(input_value[0].y);
      output_value[2] = (uchar)(input_value[0].z);
      for (int k = 0; k < 3; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k];
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
  }
  else if (remain_rows == 2) {
    if (remain_cols >= 4) {
      uchar2 output_value[4];
      output_value[0] = (uchar2)(input_value[0].x, input_value[1].x);
      output_value[1] = (uchar2)(input_value[0].y, input_value[1].y);
      output_value[2] = (uchar2)(input_value[0].z, input_value[1].z);
      output_value[3] = (uchar2)(input_value[0].w, input_value[1].w);
      for (int k = 0; k < 4; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 1) {
      uchar2 output_value[1];
      output_value[0] = (uchar2)(input_value[0].x, input_value[1].x);
      for (int k = 0; k < 1; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 2) {
      uchar2 output_value[2];
      output_value[0] = (uchar2)(input_value[0].x, input_value[1].x);
      output_value[1] = (uchar2)(input_value[0].y, input_value[1].y);
      for (int k = 0; k < 2; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 3) {
      uchar2 output_value[3];
      output_value[0] = (uchar2)(input_value[0].x, input_value[1].x);
      output_value[1] = (uchar2)(input_value[0].y, input_value[1].y);
      output_value[2] = (uchar2)(input_value[0].z, input_value[1].z);
      for (int k = 0; k < 3; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
  }
  else if (remain_rows == 3) {
    if (remain_cols >= 4) {
      uchar3 output_value[4];
      output_value[0] =
          (uchar3)(input_value[0].x, input_value[1].x, input_value[2].x);
      output_value[1] =
          (uchar3)(input_value[0].y, input_value[1].y, input_value[2].y);
      output_value[2] =
          (uchar3)(input_value[0].z, input_value[1].z, input_value[2].z);
      output_value[3] =
          (uchar3)(input_value[0].w, input_value[1].w, input_value[2].w);
      for (int k = 0; k < 4; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst[offset + 2] = output_value[k].z;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 1) {
      uchar3 output_value[1];
      output_value[0] =
          (uchar3)(input_value[0].x, input_value[1].x, input_value[2].x);
      for (int k = 0; k < 1; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst[offset + 2] = output_value[k].z;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 2) {
      uchar3 output_value[2];
      output_value[0] =
          (uchar3)(input_value[0].x, input_value[1].x, input_value[2].x);
      output_value[1] =
          (uchar3)(input_value[0].y, input_value[1].y, input_value[2].y);
      for (int k = 0; k < 2; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst[offset + 2] = output_value[k].z;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 3) {
      uchar3 output_value[3];
      output_value[0] =
          (uchar3)(input_value[0].x, input_value[1].x, input_value[2].x);
      output_value[1] =
          (uchar3)(input_value[0].y, input_value[1].y, input_value[2].y);
      output_value[2] =
          (uchar3)(input_value[0].z, input_value[1].z, input_value[2].z);
      for (int k = 0; k < 3; k++) {
        int offset = element_y * 4;
        dst[offset] = output_value[k].x;
        dst[offset + 1] = output_value[k].y;
        dst[offset + 2] = output_value[k].z;
        dst = (global uchar*)((uchar*)dst + dst_stride);
      }
    }
  }
}
#endif

#if defined(TRANSPOSE_U8C3) || defined(ALL_KERNELS)
__kernel
void transposeU8C3Kernel(global const uchar* src, int rows, int cols,
                         int src_stride, global uchar* dst, int dst_stride) {
  int element_x = get_global_id(0);
  int element_y = get_global_id(1);
  int index_x = element_x, index_y = element_y * 4;
  if (index_x >= cols || index_y >= rows) {
    return;
  }
  src = (global const uchar*)((uchar*)src + index_y * src_stride);
  int remain_rows = rows - index_y;
  uchar3 input_value[4];
  for (int i = 0; i < min(remain_rows, 4); i++) {
    input_value[i] = vload3(element_x, src);
    src = (global const uchar*)((uchar*)src + src_stride);
  }
  dst = (global uchar*)((uchar*)dst + dst_stride * index_x);
  if (remain_rows >= 4) {
    for (int i = 0; i < 4; i++) {
      vstore3(input_value[i], index_y + i, dst);
    }
  }
  else if (remain_rows == 1) {
    vstore3(input_value[0], index_y, dst);
  }
  else if (remain_rows == 2) {
    vstore3(input_value[0], index_y, dst);
    vstore3(input_value[1], index_y + 1, dst);
  }
  else if (remain_rows == 3) {
    vstore3(input_value[0], index_y, dst);
    vstore3(input_value[1], index_y + 1, dst);
    vstore3(input_value[2], index_y + 2, dst);
  }
}
#endif

#if defined(TRANSPOSE_U8C4) || defined(ALL_KERNELS)
__kernel
void transposeU8C4Kernel(global const uchar* src, int rows, int cols,
                         int src_stride, global uchar* dst, int dst_stride) {
  int element_x = get_global_id(0);
  int element_y = get_global_id(1);
  int index_x = element_x, index_y = element_y * 4;
  if (index_x >= cols || index_y >= rows) {
    return;
  }
  src = (global const uchar*)((uchar*)src + index_y * src_stride);
  int remain_rows = rows - index_y;
  uchar4 input_value[4];
  for (int i = 0; i < min(remain_rows, 4); i++) {
    input_value[i] = vload4(element_x, src);
    src = (global const uchar*)((uchar*)src + src_stride);
  }
  dst = (global uchar*)((uchar*)dst + dst_stride * index_x);
  if (remain_rows >= 4) {
    for (int i = 0; i < 4; i++) {
      vstore4(input_value[i], index_y + i, dst);
    }
  }
  else if (remain_rows == 1) {
    vstore4(input_value[0], index_y, dst);
  }
  else if (remain_rows == 2) {
    vstore4(input_value[0], index_y, dst);
    vstore4(input_value[1], index_y + 1, dst);
  }
  else if (remain_rows == 3) {
    vstore4(input_value[0], index_y, dst);
    vstore4(input_value[1], index_y + 1, dst);
    vstore4(input_value[2], index_y + 2, dst);
  }
}
#endif

#if defined(TRANSPOSE_F32C1) || defined(ALL_KERNELS)
__kernel
void transposeF32C1Kernel(global const float* src, int rows, int cols,
                          int src_stride, global float* dst, int dst_stride) {
  int element_x = get_global_id(0);
  int element_y = get_global_id(1);
  int index_x = element_x * 2, index_y = element_y * 2;
  if (index_x >= cols || index_y >= rows) {
    return;
  }
  src = (global const float*)((uchar*)src + index_y * src_stride);
  int remain_cols = cols - index_x, remain_rows = rows - index_y;
  float2 input_value[2];
  for (int i = 0; i < min(remain_rows, 2); i++) {
    input_value[i] = vload2(element_x, src);
    src = (global const float*)((uchar*)src + src_stride);
  }
  dst = (global float*)((uchar*)dst + dst_stride * index_x);
  if (remain_rows >= 2) {
    if (remain_cols >= 2) {
      float2 output_value[2];
      output_value[0] = (float2)(input_value[0].x, input_value[1].x);
      output_value[1] = (float2)(input_value[0].y, input_value[1].y);
      for (int k = 0; k < 2; k++) {
        vstore2(output_value[k], element_y, dst);
        dst = (global float*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 1) {
      float2 output_value[1];
      output_value[0] = (float2)(input_value[0].x, input_value[1].x);
      for (int k = 0; k < 1; k++) {
        vstore2(output_value[k], element_y, dst);
        dst = (global float*)((uchar*)dst + dst_stride);
      }
    }
  }
  else if (remain_rows == 1) {
    if (remain_cols >= 2) {
      float output_value[2];
      output_value[0] = (float)(input_value[0].x);
      output_value[1] = (float)(input_value[0].y);
      for (int k = 0; k < 2; k++) {
        int offset = element_y * 2;
        dst[offset] = output_value[k];
        dst = (global float*)((uchar*)dst + dst_stride);
      }
    }
    else if (remain_cols == 1) {
      float output_value[1];
      output_value[0] = (float)(input_value[0].x);
      for (int k = 0; k < 1; k++) {
        int offset = element_y * 2;
        dst[offset] = output_value[k];
        dst = (global float*)((uchar*)dst + dst_stride);
      }
    }
  }
}
#endif

#if defined(TRANSPOSE_F32C3) || defined(ALL_KERNELS)
__kernel
void transposeF32C3Kernel(global const float* src, int rows, int cols,
                          int src_stride, global float* dst, int dst_stride) {
  int element_x = get_global_id(0);
  int element_y = get_global_id(1);
  int index_x = element_x, index_y = element_y * 1;
  if (index_x >= cols || index_y >= rows) {
    return;
  }
  src = (global const float*)((uchar*)src + index_y * src_stride);
  int remain_rows = rows - index_y;
  float3 input_value[1];
  for (int i = 0; i < min(remain_rows, 1); i++) {
    input_value[i] = vload3(element_x, src);
    src = (global const float*)((uchar*)src + src_stride);
  }
  dst = (global float*)((uchar*)dst + dst_stride * index_x);
  if (remain_rows >= 1) {
    for (int i = 0; i < 1; i++) {
      vstore3(input_value[i], index_y + i, dst);
    }
  }
}
#endif

#if defined(TRANSPOSE_F32C4) || defined(ALL_KERNELS)
__kernel
void transposeF32C4Kernel(global const float* src, int rows, int cols,
                          int src_stride, global float* dst, int dst_stride) {
  int element_x = get_global_id(0);
  int element_y = get_global_id(1);
  int index_x = element_x, index_y = element_y * 1;
  if (index_x >= cols || index_y >= rows) {
    return;
  }
  src = (global const float*)((uchar*)src + index_y * src_stride);
  int remain_rows = rows - index_y;
  float4 input_value[1];
  for (int i = 0; i < min(remain_rows, 1); i++) {
    input_value[i] = vload4(element_x, src);
    src = (global const float*)((uchar*)src + src_stride);
  }
  dst = (global float*)((uchar*)dst + dst_stride * index_x);
  if (remain_rows >= 1) {
    for (int i = 0; i < 1; i++) {
      vstore4(input_value[i], index_y + i, dst);
    }
  }
}
#endif